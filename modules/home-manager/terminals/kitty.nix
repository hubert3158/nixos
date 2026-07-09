# Kitty terminal configuration — Kanagawa Wave (Ink & Wave design system)
# Palette reference: docs/THEME.md
{ config, lib, pkgs, ... }:

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
        background = "#1F1F28";
        background_image = "${config.home.homeDirectory}/nixos/images/walls/great-wave-ink.png";
        background_image_layout = "cscaled";
        background_tint = "0.95";

        foreground = "#DCD7BA";
        selection_background = "#2D4F67";
        selection_foreground = "#C8C093";
        cursor = "#C8C093";
        cursor_text_color = "#1F1F28";

        # animated cursor smear — pure nerd candy
        cursor_trail = 3;
        cursor_trail_decay = "0.1 0.4";

        url_color = "#7FB4CA";
        window_padding_width = 8;

        # tab bar — ink powerline, crystalBlue active tab
        tab_bar_style = "powerline";
        tab_powerline_style = "slanted";
        active_tab_background = "#7E9CD8";
        active_tab_foreground = "#16161D";
        inactive_tab_background = "#16161D";
        inactive_tab_foreground = "#727169";
        tab_bar_background = "#16161D";

        # 16-color palette — Kanagawa Wave
        color0 = "#16161D";
        color8 = "#727169";
        color1 = "#C34043";
        color9 = "#E82424";
        color2 = "#76946A";
        color10 = "#98BB6C";
        color3 = "#C0A36E";
        color11 = "#E6C384";
        color4 = "#7E9CD8";
        color12 = "#7FB4CA";
        color5 = "#957FB8";
        color13 = "#938AA9";
        color6 = "#6A9589";
        color14 = "#7AA89F";
        color7 = "#C8C093";
        color15 = "#DCD7BA";
        color16 = "#FFA066";
        color17 = "#FF5D62";
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
