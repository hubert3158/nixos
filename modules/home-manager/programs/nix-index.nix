# Nix-index configuration (command-not-found replacement)
{ config, lib, pkgs, ... }:

let
  cfg = config.modules.programs.nixIndex;
in
{
  options.modules.programs.nixIndex = {
    enable = lib.mkEnableOption "nix-index";
  };

  config = lib.mkIf cfg.enable {
    programs.nix-index = {
      enable = true;
      enableZshIntegration = true;
      enableBashIntegration = true;
      enableFishIntegration = true;
    };
  };
}
