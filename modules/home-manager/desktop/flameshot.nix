# Flameshot screenshot tool configuration
{ config, lib, pkgs, ... }:

let
  cfg = config.modules.desktop.flameshot;
in
{
  options.modules.desktop.flameshot = {
    enable = lib.mkEnableOption "Flameshot screenshot tool";

    savePath = lib.mkOption {
      type = lib.types.str;
      default = "/home/hubert/Pictures/Screenshots";
      description = "Path to save screenshots";
    };
  };

  config = lib.mkIf cfg.enable {
    services.flameshot = {
      enable = true;

      settings = {
        General = {
          disabledTrayIcon = true;
          showStartupLaunchMessage = false;
          useGrimAdapter = true;  # Wayland screenshot adapter
          savePath = cfg.savePath;
        };

        Shortcuts = {
          TYPE_COPY = "Ctrl+Shift+C";
          TYPE_SAVE = "Ctrl+Shift+S";
        };
      };
    };
  };
}
