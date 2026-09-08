# Hyprland user configuration
{ config, lib, pkgs, ... }:

let
  cfg = config.modules.desktop.hyprland;

  # nixpkgs pins hypr-dynamic-cursors at a rev that predates the Hyprland it
  # ships, and the plugin resolves Hyprland internals by function signature at
  # init — a mismatch paints a red error overlay across the top of the screen:
  #   [dynamic-cursors] cannot load, unexpected function signature
  #   ... plugin crashed/threw in main: std::exception
  # The rev must therefore be the one upstream's own hyprpm.toml `commit_pins`
  # lists for the Hyprland version in use. Do NOT use the plugin's HEAD: it
  # tracks Hyprland git main, which moved the IPC to
  # hyprland/src/ipc/s2/S2.hpp — a header 0.56.2 does not ship, so it fails to
  # compile.
  #
  # These values are GENERATED — do not hand-edit. Run:
  #   ./scripts/update-hypr-dynamic-cursors.sh
  dynamicCursorsPin = {
    hyprlandVersion = "0.56.2"; # Hyprland version upstream pins this rev to
    version = "0-unstable-2026-08-03";
    rev = "5a224284872208b5324759d535d65061043725de";
    hash = "sha256-BQjuQplkQFA30/7evDxmEAvr2ArIG09JffEBQhuzo80=";
  };

  # Two eval-time guards, both plain nixpkgs attribute reads (no IFD):
  #   * Hyprland moved    → the pin is for the wrong Hyprland, re-run the script
  #   * nixpkgs caught up → the override is dead weight, delete it
  hyprDynamicCursors =
    lib.warnIf (pkgs.hyprland.version != dynamicCursorsPin.hyprlandVersion)
      ("hypr-dynamic-cursors: rev is pinned for Hyprland ${dynamicCursorsPin.hyprlandVersion} "
        + "but nixpkgs now ships ${pkgs.hyprland.version}. Run "
        + "./scripts/update-hypr-dynamic-cursors.sh — a stale pin means a red "
        + "'unexpected function signature' overlay at login.")
      (lib.warnIf (pkgs.hyprlandPlugins.hypr-dynamic-cursors.src.rev == dynamicCursorsPin.rev)
        ("hypr-dynamic-cursors: nixpkgs now ships the pinned rev — the overrideAttrs "
          + "block in modules/home-manager/desktop/hyprland.nix can be deleted.")
        (pkgs.hyprlandPlugins.hypr-dynamic-cursors.overrideAttrs (_: {
          inherit (dynamicCursorsPin) version;
          src = pkgs.fetchFromGitHub {
            owner = "VirtCode";
            repo = "hypr-dynamic-cursors";
            inherit (dynamicCursorsPin) rev hash;
          };
        })));
in
{
  options.modules.desktop.hyprland = {
    enable = lib.mkEnableOption "Hyprland user configuration";

    enableXwayland = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Enable XWayland support";
    };

    configFile = lib.mkOption {
      type = lib.types.str;
      default = "${config.home.homeDirectory}/nixos/dotfiles/hypr/hyprland.lua";
      description = "Path to external Hyprland Lua config file";
    };
  };

  config = lib.mkIf cfg.enable {
    wayland.windowManager.hyprland = {
      enable = true;
      # Lua, not hyprlang: Hyprland 0.56 deprecated the .conf format and drops
      # it in 0.57. Home Manager writes ~/.config/hypr/hyprland.lua (plus a
      # .luarc.json pointing lua-ls at the stubs shipped with the package).
      configType = "lua";
      xwayland.enable = cfg.enableXwayland;
      # Disable systemd integration as it conflicts with uwsm
      systemd.enable = false;
      # Plugins are loaded before extraConfig sources the dotfile, so the
      # plugin{} block and overview binds there resolve correctly.
      plugins = [
        # hyprspace (workspace overview, Mod+grave) is disabled: Hyprland 0.56
        # moved src/managers/animation/AnimationManager.hpp to
        # src/animation/AnimationManager.hpp and upstream Hyprspace (pinned in
        # nixpkgs at c109256, 2026-05-28) still includes the old path, so the
        # plugin no longer compiles. Re-enable once nixpkgs ships a rev that
        # builds against 0.56 (PR KZDKM/Hyprspace#238 is the candidate).
        # pkgs.hyprlandPlugins.hyprspace

        # cursor tilt + shake-to-find, rev-pinned to match Hyprland — see
        # dynamicCursorsPin in the let block above, which also carries the two
        # drift warnings.
        hyprDynamicCursors
      ];
      # require() with an absolute path registers the dotfile with Hyprland's
      # inotify watcher (plain dofile() would not), so saving it reloads live.
      extraConfig = ''require("${cfg.configFile}")'';
    };
  };
}
