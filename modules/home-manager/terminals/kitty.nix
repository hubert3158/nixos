# Kitty terminal configuration
{ config, lib, pkgs, ... }:

let
  cfg = config.modules.terminals.kitty;
in
{
  options.modules.terminals.kitty = {
    enable = lib.mkEnableOption "Kitty terminal";

    fontName = lib.mkOption {
      type = lib.types.str;
      default = "JetBrainsMono Nerd Font";
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
        package = pkgs.nerd-fonts.jetbrains-mono;
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

        # Catppuccin Macchiato over the red-moon background image
        background = "#181926";
        background_image = "${config.home.homeDirectory}/nixos/images/kitty-wallpaper.jpg";
        background_image_layout = "cscaled";
        background_tint = "0.25"; # darken the image so text stays readable

        foreground = "#cad3f5";
        selection_background = "#494d64";
        selection_foreground = "#cad3f5";
        cursor = "#f4dbd6";
        cursor_text_color = "#24273a";

        # animated cursor smear — pure nerd candy
        cursor_trail = 3;
        cursor_trail_decay = "0.1 0.4";

        url_color = "#8aadf4";
        window_padding_width = 6;

        # tab bar, macchiato powerline
        tab_bar_style = "powerline";
        tab_powerline_style = "slanted";
        active_tab_background = "#7dc4e4";
        active_tab_foreground = "#181926";
        inactive_tab_background = "#1e2030";
        inactive_tab_foreground = "#6e738d";

        # 16-color palette
        color0 = "#494d64";
        color8 = "#5b6078";
        color1 = "#ed8796";
        color9 = "#ed8796";
        color2 = "#a6da95";
        color10 = "#a6da95";
        color3 = "#eed49f";
        color11 = "#eed49f";
        color4 = "#8aadf4";
        color12 = "#8aadf4";
        color5 = "#f5bde6";
        color13 = "#f5bde6";
        color6 = "#8bd5ca";
        color14 = "#8bd5ca";
        color7 = "#b8c0e0";
        color15 = "#a5adcb";
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
