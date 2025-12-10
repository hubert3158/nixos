# Bat (cat replacement) configuration
{ config, lib, pkgs, ... }:

let
  cfg = config.modules.tools.bat;
in
{
  options.modules.tools.bat = {
    enable = lib.mkEnableOption "Bat (cat replacement)";

    enableExtras = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Enable bat extras (batdiff, batman, etc.)";
    };
  };

  config = lib.mkIf cfg.enable {
    programs.bat = {
      enable = true;
      extraPackages = lib.mkIf cfg.enableExtras (with pkgs.bat-extras; [
        batdiff
        batman
        batpipe
        batwatch
        prettybat
      ]);
    };
  };
}
