# Tmux configuration
{ config, lib, pkgs, ... }:

let
  cfg = config.modules.programs.tmux;
in
{
  options.modules.programs.tmux = {
    enable = lib.mkEnableOption "Tmux terminal multiplexer";

    clock24 = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Use 24-hour clock";
    };

    enableMouse = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Enable mouse support";
    };
  };

  config = lib.mkIf cfg.enable {
    programs.tmux = {
      enable = true;
      clock24 = cfg.clock24;
      plugins = with pkgs.tmuxPlugins; [
        sensible
        yank
        resurrect
        {
          plugin = catppuccin;
          extraConfig = '''';
        }
      ];

      extraConfig = ''
        set -g mouse ${if cfg.enableMouse then "on" else "off"}
        set-option -g allow-passthrough all
      '';
    };
  };
}
