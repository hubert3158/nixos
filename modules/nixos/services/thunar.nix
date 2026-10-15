# Thunar GUI file manager + removable media (USB/MTP shown in sidebar, click to mount)
{ config, lib, pkgs, ... }:

let
  cfg = config.modules.services.thunar;
in
{
  options.modules.services.thunar = {
    enable = lib.mkEnableOption "Thunar file manager with gvfs/udisks2 removable media";
  };

  config = lib.mkIf cfg.enable {
    programs.thunar.enable = true;
    programs.xfconf.enable = true; # persist Thunar preferences
    services.gvfs.enable = true; # drives/MTP/trash/network in sidebar
    services.udisks2.enable = true; # mount backend
    services.tumbler.enable = true; # thumbnails
  };
}
