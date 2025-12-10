# Fish shell configuration
{ config, lib, pkgs, ... }:

let
  cfg = config.modules.shell.fish;
in
{
  options.modules.shell.fish = {
    enable = lib.mkEnableOption "Fish shell";
  };

  config = lib.mkIf cfg.enable {
    programs.fish = {
      enable = true;
      interactiveShellInit = ''
        set -g fish_greeting ""
        set -Ux EDITOR nvim
        set -Ux VISUAL nvim
        set -Ux PAGER less

        # Enable Starship prompt
        starship init fish | source
      '';
    };

    home.packages = with pkgs; [
      fish
      starship
    ];
  };
}
