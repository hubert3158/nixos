# Eza (ls replacement) configuration
{ config, lib, pkgs, ... }:

let
  cfg = config.modules.tools.eza;
in
{
  options.modules.tools.eza = {
    enable = lib.mkEnableOption "Eza (ls replacement)";
  };

  config = lib.mkIf cfg.enable {
    programs.eza = {
      enable = true;
      colors = "always";
      enableZshIntegration = true;
      icons = "always";
    };
  };
}
