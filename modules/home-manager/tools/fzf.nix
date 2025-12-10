# FZF fuzzy finder configuration
{ config, lib, pkgs, ... }:

let
  cfg = config.modules.tools.fzf;
in
{
  options.modules.tools.fzf = {
    enable = lib.mkEnableOption "FZF fuzzy finder";
  };

  config = lib.mkIf cfg.enable {
    programs.fzf = {
      enable = true;
      enableZshIntegration = true;
    };
  };
}
