# Wezterm terminal configuration
{ config, lib, pkgs, ... }:

let
  cfg = config.modules.terminals.wezterm;
in
{
  options.modules.terminals.wezterm = {
    enable = lib.mkEnableOption "Wezterm terminal";

    font = lib.mkOption {
      type = lib.types.str;
      default = "JetBrains Mono";
      description = "Font family";
    };

    fontSize = lib.mkOption {
      type = lib.types.number;
      default = 16.0;
      description = "Font size";
    };

    colorScheme = lib.mkOption {
      type = lib.types.str;
      default = "Catppuccin Frappe";
      description = "Color scheme";
    };

    enableTmuxOnStart = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Start tmux session on terminal launch";
    };
  };

  config = lib.mkIf cfg.enable {
    programs.wezterm = {
      enable = true;
      extraConfig = ''
        return {
          font = wezterm.font("${cfg.font}"),
          font_size = ${toString cfg.fontSize},
          color_scheme = "${cfg.colorScheme}",
          hide_tab_bar_if_only_one_tab = true,
          ${lib.optionalString cfg.enableTmuxOnStart ''default_prog = { "zsh", "--login", "-c", "tmux attach -t dev || tmux new -s dev" },''}
          keys = {
            {key="n", mods="SHIFT|CTRL", action=wezterm.action.ToggleFullScreen},
          },
          window_background_image = '/home/hubert/nixos/images/wallpaper.png',
          window_background_image_hsb = {
            brightness = 0.5,
            hue = 0.5,
            saturation = 0.7,
          },
        }
      '';
    };
  };
}
