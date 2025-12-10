# i3 window manager configuration
{ config, lib, pkgs, ... }:

let
  cfg = config.modules.desktop.i3;
in
{
  options.modules.desktop.i3 = {
    enable = lib.mkEnableOption "i3 window manager";
  };

  config = lib.mkIf cfg.enable {
    # i3 is typically configured through home-manager
    # This just ensures the package is available system-wide
    environment.systemPackages = with pkgs; [
      i3
      rofi
      dmenu
      xorg.xrandr
    ];
  };
}
