# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs,lib, ... }:

{


  programs.hyprland.enable  = true;

   services.xserver = {
    enable = true;
    desktopManager.xfce.enable = true;
    windowManager.i3.enable = true;
    videoDrivers = [ "nvidia" ];
    xkb.layout = "us";
    xkb.variant = "";
  };

  services.displayManager.sddm.enable = true;

  hardware = {
    graphics = {
      enable = true;
      enable32Bit = true;
      extraPackages = with pkgs; [
        vaapiIntel
        vaapiVdpau
        libvdpau
      ];
    };
    bluetooth.enable = true;
    nvidia = {
      open = true;
      modesetting.enable =  true;
      package = config.boot.kernelPackages.nvidiaPackages.stable; 
    nvidiaPersistenced = true;
  };
};
networking.firewall.allowedTCPPorts = [ 3000 8080 8081 993 5678 5000];
}
