# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs,lib, ... }:

{

  imports =
    [ 
      #./hardware-configuration-work.nix
    ];

  services.xserver.enable = true;
  # Configure keymap in X11
  services.xserver = {
    xkb.layout = "us";
    xkb.variant = "";
  };

  # Enable the KDE Plasma Desktop Environment.
#   services.displayManager.sddm.enable = true;
# services.desktopManager.plasma6.enable = true;
#services.xserver.desktopManager.gnome.enable = true;
 # services.xserver.desktopManager.xfce.enable = true;
  services.xserver.displayManager.lightdm.enable = true;

  services.desktopManager.plasma6.enable = true;
    services.displayManager.sddm.wayland.enable = true;




  hardware.graphics.enable = true;

networking.firewall.allowedTCPPorts = [ 3000];


}
