# SDDM Display Manager configuration
{ config, lib, pkgs, ... }:

let
  cfg = config.modules.desktop.sddm;
in
{
  options.modules.desktop.sddm = {
    enable = lib.mkEnableOption "SDDM display manager";

    enableXserver = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Enable X server alongside SDDM";
    };

    xkbLayout = lib.mkOption {
      type = lib.types.str;
      default = "us";
      description = "Keyboard layout";
    };

    xkbVariant = lib.mkOption {
      type = lib.types.str;
      default = "";
      description = "Keyboard variant";
    };
  };

  config = lib.mkIf cfg.enable {
    services.displayManager.sddm.enable = true;

    services.xserver = {
      enable = cfg.enableXserver;
      xkb.layout = cfg.xkbLayout;
      xkb.variant = cfg.xkbVariant;
    };

    # Enable envfs for compatibility
    services.envfs.enable = true;
  };
}
