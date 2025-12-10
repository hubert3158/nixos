# Media tools configuration
{ config, lib, pkgs, ... }:

let
  cfg = config.modules.programs.media;
in
{
  options.modules.programs.media = {
    enable = lib.mkEnableOption "media tools";

    enableZathura = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Enable Zathura PDF viewer";
    };

    enableMpv = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Enable MPV media player";
    };
  };

  config = lib.mkIf cfg.enable {
    programs.zathura.enable = cfg.enableZathura;
    programs.mpv.enable = cfg.enableMpv;
  };
}
