# Edit this configuration file to define what should be installed on
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
  # services.desktopManager.plasma6.enable = true;
   services.xserver = {
    enable = true;
    desktopManager.xfce.enable = true;
  };
  # programs.hyprland.enable  = true;
  services.displayManager.sddm.enable = true;

  services.xserver = {
    videoDrivers = [ "nvidia" ];
  };

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
    #Fixes a glitch
    nvidiaPersistenced = true;
    #Required for amdgpu and nvidia gpu pairings
    # prime = {
    #   offload.enable = true;
    #    #sync.enable = true;
    #    amdgpuBusId = "PCI:5:0:0";
    #    nvidiaBusId = "PCI:1:0:0";
    #  };

  };
};
}
