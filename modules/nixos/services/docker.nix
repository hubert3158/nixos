# Docker container runtime configuration
{ config, lib, pkgs, ... }:

let
  cfg = config.modules.services.docker;
in
{
  options.modules.services.docker = {
    enable = lib.mkEnableOption "Docker container runtime";

    rootless = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable rootless Docker";
    };
  };

  config = lib.mkIf cfg.enable {
    virtualisation.docker = {
      enable = true;
      rootless.enable = cfg.rootless;
    };
  };
}
