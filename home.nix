# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs,lib, ... }:

{

hardware.nvidia.modesetting.enable =  true;
hardware.nvidia.open = true;

  imports =
    [ 
    #  ./hardware-configuration-home.nix
    ];

   services.xserver.enable = true;
  # # Configure keymap in X11
  services.xserver = {
    xkb.layout = "us";
    xkb.variant = "";
  };



  services.displayManager.sddm.wayland.enable = true ;


  # wayland.inputDevices = {
  #   layout = "us";  # Set your desired keyboard layout
  #   variant = "";   # Optionally set the variant
  # };




  # Enable the KDE Plasma Desktop Environment.
  services.displayManager.sddm.enable = true;
services.desktopManager.plasma6.enable = true;
# services.xserver.desktopManager.gnome.enable = true;
  # services.xserver.desktopManager.xfce.enable = true;
  # Enable Hyprland
# Enable Sway
#services.wayland.windowManager.sway.enable = true;
# Enable Weston
#services.wayland.windowManager.weston.enable = true;
#  wayland.windowManager.sway.enable = true;



  hardware.graphics.enable = true;

  services.xserver.videoDrivers = [ "nvidia" ];


}
