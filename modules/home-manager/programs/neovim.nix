# Neovim configuration (uses overlay)
{ config, lib, pkgs, ... }:

let
  cfg = config.modules.programs.neovim;
in
{
  options.modules.programs.neovim = {
    enable = lib.mkEnableOption "Neovim editor";
  };

  config = lib.mkIf cfg.enable {
    # The neovim package itself comes from the overlay (nvim-pkg)
    # This module just ensures it's properly integrated with home-manager
    programs.neomutt = {
      enable = true;
      editor = "nvim";
    };
  };
}
