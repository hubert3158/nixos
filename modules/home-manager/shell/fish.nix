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
        # EDITOR/VISUAL/PAGER come from environment.sessionVariables —
        # `set -Ux` here would persist universal vars outside Nix management.

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
