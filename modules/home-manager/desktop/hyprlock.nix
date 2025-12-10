# Hyprlock configuration
{ config, lib, pkgs, ... }:

let
  cfg = config.modules.desktop.hyprlock;
in
{
  options.modules.desktop.hyprlock = {
    enable = lib.mkEnableOption "Hyprlock screen locker";

    wallpaper = lib.mkOption {
      type = lib.types.str;
      default = "~/nixos/images/wallpaper.png";
      description = "Path to lock screen wallpaper";
    };

    gracePeriod = lib.mkOption {
      type = lib.types.int;
      default = 300;
      description = "Grace period before locking in seconds";
    };
  };

  config = lib.mkIf cfg.enable {
    programs.hyprlock = {
      enable = true;
      settings = {
        general = {
          disable_loading_bar = true;
          grace = cfg.gracePeriod;
          hide_cursor = true;
          no_fade_in = false;
        };

        background = [
          {
            path = cfg.wallpaper;
            blur_passes = 3;
            blur_size = 8;
          }
        ];

        input-field = [
          {
            size = "200, 50";
            position = "0, -80";
            monitor = "";
            dots_center = true;
            fade_on_empty = false;
            font_color = "rgb(202, 211, 245)";
            inner_color = "rgb(91, 96, 120)";
            outer_color = "rgb(24, 25, 38)";
            outline_thickness = 5;
            placeholder_text = ''<span foreground="##cad3f5">Password...</span>'';
            shadow_passes = 2;
          }
        ];
      };
    };
  };
}
