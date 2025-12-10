# Graphics and GPU configuration
{ config, lib, pkgs, ... }:

let
  cfg = config.modules.hardware.graphics;
in
{
  options.modules.hardware.graphics = {
    enable = lib.mkEnableOption "graphics/GPU support";

    enableVdpau = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Enable VDPAU hardware acceleration";
    };
  };

  config = lib.mkIf cfg.enable {
    hardware.graphics = {
      enable = true;
      extraPackages = lib.mkIf cfg.enableVdpau (with pkgs; [
        libva-vdpau-driver
        libvdpau
      ]);
    };
  };
}
