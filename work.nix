# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs,lib, ... }:

{

  imports =
    [ 
      #./hardware-configuration-work.nix
    ];


  # Enable the KDE Plasma Desktop Environment.
  services.displayManager.sddm.enable = true;
services.desktopManager.plasma6.enable = true;
#services.xserver.desktopManager.gnome.enable = true;
#  services.xserver.desktopManager.xfce.enable = true;

  hardware.graphics.enable = true;

#  services.xserver.videoDrivers = [ "nvidia" ];


}
