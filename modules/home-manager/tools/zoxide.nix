# Zoxide (cd replacement) configuration
{ config, lib, pkgs, ... }:

let
  cfg = config.modules.tools.zoxide;
in
{
  options.modules.tools.zoxide = {
    enable = lib.mkEnableOption "Zoxide (cd replacement)";
  };

  config = lib.mkIf cfg.enable {
    programs.zoxide = {
      enable = true;
      package = pkgs.zoxide;
      options = [];
      enableZshIntegration = true;
    };
  };
}
