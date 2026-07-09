# Doom Emacs (with evil/vim keybindings).
#
# Why imperative bootstrap instead of a declarative nix-doom flake:
# Doom uses straight.el, which downloads and byte-compiles every elisp package
# at runtime (outside Nix). A declarative `nix-doom-emacs-unstraightened` setup
# would route all of that through Nix — hundreds of non-cached derivations and
# hours of local compilation, violating this repo's "avoid local builds" rule.
# So we install the cached `emacs-pgtk` binary + Doom's deps via Nix, then let
# Doom manage its own packages the normal way. You edit ~/.config/doom and run
# `doom sync` exactly as upstream docs describe.
#
# Layout (XDG):
#   ~/.config/emacs  -> Doom itself (git clone, provides the `doom` CLI on PATH)
#   ~/.config/doom   -> your private config (init.el / config.el / packages.el)
{ config, lib, pkgs, ... }:

let
  cfg = config.modules.programs.emacs;
in
{
  options.modules.programs.emacs = {
    enable = lib.mkEnableOption "Doom Emacs (evil mode)";

    daemon = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = ''
        Run an Emacs server (systemd user service) so `emacsclient` opens
        instantly. Use `emacsclient -c` for a GUI frame or `-t` for a terminal.
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    # emacs-pgtk = pure-GTK build with native Wayland support (Hyprland). All of
    # these are in the binary cache, so nothing compiles locally.
    home.packages = with pkgs; [
      emacs-pgtk
      git          # straight.el clones packages over git
      ripgrep      # powers Doom's search (projectile, +default search)
      fd           # faster file finding
      coreutils
      # The icon font Doom's UI (nerd-icons, modeline, dashboard) renders with.
      # Provided declaratively here so we never need `doom install`'s interactive
      # font prompt — otherwise you'd see tofu boxes (□) in the UI.
      nerd-fonts.symbols-only
      (lib.lowPrio binutils)  # native-comp / some packages shell out to `ar`
    ];

    # Make the `doom` CLI available without typing the full path.
    home.sessionPath = [ "$HOME/.config/emacs/bin" ];

    # Optional background server for instant emacsclient startup.
    services.emacs = lib.mkIf cfg.daemon {
      enable = true;
      package = pkgs.emacs-pgtk;
      client.enable = true;
    };

    # Bootstrap on every `nixos-rebuild switch`, but idempotent and non-fatal —
    # a failure here only warns, it never aborts the rebuild:
    #   1. clone Doom only if ~/.config/emacs is missing
    #   2. seed the private config only if a file is missing (never clobbers edits)
    #   3. run `doom sync` exactly ONCE (gated by a sentinel), to download and
    #      byte-compile packages so the first `emacs`/daemon start just works.
    #
    # `doom sync` (not `doom install`) is used on purpose: it's non-interactive,
    # whereas `doom install` prompts for fonts/env. Icon fonts come from nix
    # (above) and the env file isn't needed for normal use. First switch after a
    # fresh clone takes a few minutes (clone + native-comp); every switch after
    # is a no-op. Edit ~/.config/doom later → run `doom sync` yourself.
    home.activation.doomEmacsBootstrap = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
      export PATH="${lib.makeBinPath [ pkgs.emacs-pgtk pkgs.git pkgs.ripgrep pkgs.fd pkgs.coreutils ]}:$PATH"

      emacsDir="$HOME/.config/emacs"
      doomDir="$HOME/.config/doom"
      sentinel="$doomDir/.doom-synced"

      if [ ! -d "$emacsDir" ]; then
        # --recurse-submodules is REQUIRED: current Doom keeps all non-core
        # modules (editor/evil, ui/doom, lang/*, ...) in the `sources/doom+`
        # git submodule. A plain clone yields only the :doom core, so every
        # module resolves as &nopath and `doom sync` installs nothing.
        $DRY_RUN_CMD git clone --depth 1 --recurse-submodules \
          https://github.com/doomemacs/doomemacs "$emacsDir" \
          || echo "warning: failed to clone Doom Emacs (network?); rerun the switch" >&2
      fi

      # Self-heal: ensure the module submodule is present even if an earlier
      # switch cloned without it (or the submodule was added upstream later).
      if [ -d "$emacsDir/.git" ]; then
        $DRY_RUN_CMD git -C "$emacsDir" submodule update --init --recursive --depth 1 \
          || echo "warning: failed to init Doom module submodule; rerun the switch" >&2
      fi

      $DRY_RUN_CMD mkdir -p "$doomDir"
      for f in init.el config.el packages.el; do
        if [ ! -e "$doomDir/$f" ]; then
          $DRY_RUN_CMD install -m 0644 "${./doom}/$f" "$doomDir/$f"
        fi
      done

      # One-time package install. Sentinel only written on success, so a failed
      # sync retries on the next switch instead of leaving Doom half-built.
      if [ ! -e "$sentinel" ] && [ -x "$emacsDir/bin/doom" ]; then
        echo "doom: first-time sync (downloads + byte-compiles packages, a few minutes)..." >&2
        if $DRY_RUN_CMD "$emacsDir/bin/doom" sync; then
          $DRY_RUN_CMD touch "$sentinel"
        else
          echo "warning: 'doom sync' failed; will retry on next switch (or run 'doom sync' by hand)" >&2
        fi
      fi
    '';
  };
}
