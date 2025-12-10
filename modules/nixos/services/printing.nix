# Printing (CUPS) configuration
{ config, lib, pkgs, ... }:

let
  cfg = config.modules.services.printing;
in
{
  options.modules.services.printing = {
    enable = lib.mkEnableOption "printing support via CUPS";
  };

  config = lib.mkIf cfg.enable {
    services.printing.enable = true;
  };
}
