# Htop/Btop system monitor configuration
{ config, lib, pkgs, ... }:

let
  cfg = config.modules.tools.htop;
in
{
  options.modules.tools.htop = {
    enable = lib.mkEnableOption "Htop system monitor";
  };

  config = lib.mkIf cfg.enable {
    programs.htop.enable = true;

    home.packages = with pkgs; [
      btop
    ];
  };
}
