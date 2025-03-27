
{ config, pkgs,lib, ... }:

{
  fileSystems."/nix/store" = {
    device = "/dev/disk/by-uuid/9c498fa9-290c-44ef-914f-aa0987369009";
    fsType = "ext4";
    options = [ "defaults" ];
  };


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
networking.firewall.allowedTCPPorts = [ 3000 8080 8081 993 5678 5000 8083];
# services.intune.enable = true;
}
