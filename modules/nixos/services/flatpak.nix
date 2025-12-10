# Flatpak configuration
{ config, lib, pkgs, ... }:

let
  cfg = config.modules.services.flatpak;
in
{
  options.modules.services.flatpak = {
    enable = lib.mkEnableOption "Flatpak support";
  };

  config = lib.mkIf cfg.enable {
    services.flatpak.enable = true;
  };
}
