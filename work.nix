# # Edit this configuration file to define what should be installed on
# # your system.  Help is available in the configuration.nix(5) man page
# # and in the NixOS manual (accessible by running ‘nixos-help’).
#
# { config, pkgs,lib, ... }:
#
# {
#
#   imports =
#     [ 
#       #./hardware-configuration-work.nix
#     ];
#
#   # Configure keymap in X11
#   services.xserver = {
#     xkb.layout = "us";
#     xkb.variant = "";
#   };
#
#    hardware.bluetooth.enable = true;
#   programs.hyprland.enable  = true;
#   services.xserver.enable = true;
#   hardware.graphics.enable = true;
#   # services.desktopManager.plasma6.enable = true;   # somehow its needed for hyprland to work
#   services.displayManager.sddm.enable = true;
#   networking.firewall.allowedTCPPorts = [ 3000 8080];
# services.intune.enable = true;
#
# }
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs,lib, ... }:

{

  ## Configure keymap in X11
  services.xserver = {
    xkb.layout = "us";
    xkb.variant = "";
  };

  programs.hyprland.enable  = true;
   services.xserver = {
    enable = true;
    desktopManager.xfce.enable = true;
    windowManager.i3.enable = true;
  };


  services.displayManager.sddm.enable = true;

  hardware = {
    graphics = {
      enable = true;
      extraPackages = with pkgs; [
        vaapiIntel
        vaapiVdpau
        libvdpau
      ];
    };
    bluetooth.enable = true;
};
networking.firewall.allowedTCPPorts = [ 3000 8080 8081 993 5678 5000];
services.intune.enable = true;
}
