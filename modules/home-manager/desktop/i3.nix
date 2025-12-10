# i3 window manager user configuration
{ config, lib, pkgs, ... }:

let
  cfg = config.modules.desktop.i3;
in
{
  options.modules.desktop.i3 = {
    enable = lib.mkEnableOption "i3 window manager user configuration";

    modifier = lib.mkOption {
      type = lib.types.str;
      default = "Mod4";
      description = "i3 modifier key (Mod4 = Super/Win key)";
    };

    terminal = lib.mkOption {
      type = lib.types.str;
      default = "kitty";
      description = "Default terminal emulator";
    };

    wallpaper = lib.mkOption {
      type = lib.types.str;
      default = "~/nixos/images/wallpaper.png";
      description = "Path to wallpaper";
    };
  };

  config = lib.mkIf cfg.enable {
    programs.feh.enable = true;

    xsession = {
      enable = true;
      windowManager.i3 = {
        enable = true;
        config = {
          fonts = {
            names = [ "DejaVu Sans Mono" "FontAwesome5Free" ];
            style = "Bold Semi-Condensed";
            size = 11.0;
          };
          modifier = cfg.modifier;
          terminal = cfg.terminal;
          keybindings = let
            modifier = config.xsession.windowManager.i3.config.modifier;
          in lib.mkOptionDefault {
            "${modifier}+q" = "exec ${cfg.terminal}";
            "${modifier}+c" = "kill";
            "${modifier}+r" = "exec rofi -show drun";
            "${modifier}+t" = "layout tabbed";
          };

          startup = [
            {
              command = "feh --bg-scale ${cfg.wallpaper}";
            }
            {
              command = "xrandr --output eDP-1 --off";
            }
          ];
        };
      };
    };
  };
}
