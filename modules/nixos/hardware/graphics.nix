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
      # Mesa already ships the native radeonsi VAAPI/VDPAU drivers;
      # the libva-vdpau-driver bridge would route VAAPI through VDPAU
      # (a worse decode path on AMD), so only the plain library stays.
      extraPackages = lib.mkIf cfg.enableVdpau (with pkgs; [
        libvdpau
      ]);
    };

    # Pin hardware video decode to Mesa's native AMD drivers
    environment.variables = {
      LIBVA_DRIVER_NAME = "radeonsi";
      VDPAU_DRIVER = "radeonsi";
    };
  };
}
