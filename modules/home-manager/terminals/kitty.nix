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
      default = "Monofur Nerd Font";
      description = "Font family";
    };

    fontSize = lib.mkOption {
      type = lib.types.number;
      default = 18;
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
      package = pkgs.kitty.overrideAttrs (_: {
        doCheck = false;
        doInstallCheck = false;
        checkInputs = [];
      });
      enableGitIntegration = true;

      font = {
        name = cfg.fontName;
        size = cfg.fontSize;
        package = pkgs.nerd-fonts.monofur;
      };

      settings = {
        shell = "${pkgs.zsh}/bin/zsh --login";

        scrollback_lines = cfg.scrollbackLines;
        enable_audio_bell = false;
        update_check_interval = 0;

        # Dracula-like colors
        background = "#282a36";
        background_image = "${config.home.homeDirectory}/nixos/images/kitty-wallpaper.jpg";
        background_image_layout = "cscaled";

        foreground = "#f8f8f2";
        selection_background = "#44475a";
        selection_foreground = "#f8f8f2";
        cursor = "#f8f8f0";
        cursor_text_color = "#282a36";
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
