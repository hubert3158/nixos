# AppImage support
{ config, lib, ... }:

let
  cfg = config.modules.services.appimage;
in
{
  options.modules.services.appimage = {
    enable = lib.mkEnableOption "AppImage support";
  };

  config = lib.mkIf cfg.enable {
    programs.appimage = {
      enable = true;
      binfmt = true; # lets you run ./whatever.AppImage directly
    };
  };
}
