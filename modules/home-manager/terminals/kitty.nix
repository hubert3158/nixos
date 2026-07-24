# Kitty terminal configuration — Kanagawa Wave (Ink & Wave design system)
# Colours from lib/palette.nix; keep in lockstep with ghostty.nix / wezterm.nix
{ config, lib, pkgs, palette, ... }:

let
  cfg = config.modules.terminals.kitty;
in
{
  options.modules.terminals.kitty = {
    enable = lib.mkEnableOption "Kitty terminal";

    fontName = lib.mkOption {
      type = lib.types.str;
      default = "Maple Mono NF";
      description = "Font family";
    };

    fontSize = lib.mkOption {
      type = lib.types.number;
      default = 14;
      description = "Font size";
    };

    scrollbackLines = lib.mkOption {
      type = lib.types.int;
      default = 10000;
      description = "Number of scrollback lines";
    };
  };

  config = lib.mkIf cfg.enable {
    programs.kitty = {
      enable = true;
      enableGitIntegration = true;

      font = {
        name = cfg.fontName;
        size = cfg.fontSize;
        package = pkgs.maple-mono.NF;
      };

      settings = {
        shell = "${pkgs.zsh}/bin/zsh --login";

        scrollback_lines = cfg.scrollbackLines;
        enable_audio_bell = false;
        update_check_interval = 0;

        # Disable the config-file watcher (kitten __watch_conf__). On kitty 0.47.1
        # with a home-manager-symlinked kitty.conf (-> /nix/store), the watcher
        # follows the symlink and recursively adds inotify watches under the nix
        # store, exhausting fs.inotify.max_user_watches (524288) within minutes of
        # boot. Every other watcher (vite dev server, IDEs) then fails with
        # ENOSPC. Auto-reload is useless under home-manager anyway: config changes
        # land as a new store path via `home-manager switch`, never as in-place
        # edits. Manual reload (ctrl+shift+f5) still works.
        auto_reload_config = -1;

        # ── Kanagawa Wave over a ghosted ink-wave background image ──
        # kitty paints the image wherever a cell's bg equals the default
        # background — which includes ALL of neovim — so the tint must be
        # near-total or code drowns in the artwork. 0.95 = faint ghost texture.
        background = palette.sumiInk3;
        background_image = "${config.home.homeDirectory}/nixos/images/walls/great-wave-ink.png";
        background_image_layout = "cscaled";
        background_tint = "0.95";

        foreground = palette.fujiWhite;
        selection_background = palette.waveBlue2;
        selection_foreground = palette.oldWhite;
        cursor = palette.oldWhite;
        cursor_text_color = palette.sumiInk3;

        # animated cursor smear — pure nerd candy
        cursor_trail = 3;
        cursor_trail_decay = "0.1 0.4";

        url_color = palette.springBlue;
        url_style = "curly";
        window_padding_width = 8;
        hide_window_decorations = "yes";
        # unfocused kitty splits fade slightly — pairs with the hyprland
        # terminal-depth windowrule for layered ink
        inactive_text_alpha = "0.85";

        # tab bar — ink powerline, crystalBlue active tab
        tab_bar_style = "powerline";
        tab_powerline_style = "slanted";
        active_tab_background = palette.crystalBlue;
        active_tab_foreground = palette.sumiInk0;
        inactive_tab_background = palette.sumiInk0;
        inactive_tab_foreground = palette.fujiGray;
        tab_bar_background = palette.sumiInk0;

        # 16-color palette — Kanagawa Wave (normal 0-7, bright 8-15)
        color0 = palette.sumiInk0;
        color8 = palette.fujiGray;
        color1 = palette.ansiRed;
        color9 = palette.samuraiRed;
        color2 = palette.ansiGreen;
        color10 = palette.springGreen;
        color3 = palette.ansiYellow;
        color11 = palette.carpYellow;
        color4 = palette.crystalBlue;
        color12 = palette.springBlue;
        color5 = palette.oniViolet;
        color13 = palette.springViolet1;
        color6 = palette.ansiCyan;
        color14 = palette.waveAqua2;
        color7 = palette.oldWhite;
        color15 = palette.fujiWhite;
        color16 = palette.surimiOrange;
        color17 = palette.peachRed;
      };

      keybindings = {
        "ctrl+c" = "copy_or_interrupt";
      };

      shellIntegration = {
        mode = "default";
        enableZshIntegration = true;
        enableBashIntegration = true;
      };
    };
  };
}
