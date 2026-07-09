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
      default = "Maple Mono NF";
      description = "Font family";
    };

    fontSize = lib.mkOption {
      type = lib.types.number;
      default = 16.0;
      description = "Font size";
    };

    colorScheme = lib.mkOption {
      type = lib.types.str;
      # matches the rest of the Ink & Wave design system (docs/THEME.md)
      default = "Kanagawa (Gogh)";
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
          window_background_image = '${config.home.homeDirectory}/nixos/images/walls/great-wave-ink.png',
          window_background_image_hsb = {
            -- ghost the wave into the ink so text stays readable
            brightness = 0.18,
            hue = 1.0,
            saturation = 0.9,
          },
        }
      '';
    };
  };
}
