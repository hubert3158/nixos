# Hyprpaper wallpaper daemon configuration
{ config, lib, pkgs, ... }:

let
  cfg = config.modules.desktop.hyprpaper;
in
{
  options.modules.desktop.hyprpaper = {
    enable = lib.mkEnableOption "Hyprpaper wallpaper daemon";

    wallpaper = lib.mkOption {
      type = lib.types.str;
      default = "/home/hubert/nixos/images/kitty-wallpaper.jpg";
      description = "Path to wallpaper image";
    };

    monitor = lib.mkOption {
      type = lib.types.str;
      default = "HDMI-A-1";
      description = "Monitor to apply wallpaper to";
    };
  };

  config = lib.mkIf cfg.enable {
    services.hyprpaper = {
      enable = true;
      settings = {
        ipc = "on";
        splash = false;
        splash_offset = 2.0;

        preload = [ cfg.wallpaper ];

        wallpaper = [
          "${cfg.monitor},${cfg.wallpaper}"
        ];
      };
    };
  };
}
