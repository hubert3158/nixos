# Delta (diff tool) configuration
# Note: Delta is typically configured through programs/git.nix
# This module is here for standalone delta usage
{ config, lib, pkgs, ... }:

let
  cfg = config.modules.tools.delta;
in
{
  options.modules.tools.delta = {
    enable = lib.mkEnableOption "Delta diff tool (standalone)";
  };

  config = lib.mkIf cfg.enable {
    home.packages = [ pkgs.delta ];
  };
}
