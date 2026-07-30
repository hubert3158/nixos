# i3 window manager user configuration — X11 fallback session, themed to
# Himal (lib/palette.nix) so dropping back to i3 doesn't mean stock blue
{ config, lib, pkgs, palette, ... }:

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
      default = "${config.home.homeDirectory}/nixos/images/wallpaper.png";
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
            names = [ "Maple Mono NF" "Noto Sans CJK JP" ];
            style = "Bold";
            size = 11.0;
          };
          modifier = cfg.modifier;
          terminal = cfg.terminal;

          colors = {
            background = palette.sumiInk3;
            focused = {
              border = palette.crystalBlue;
              childBorder = palette.crystalBlue;
              background = palette.sumiInk3;
              text = palette.fujiWhite;
              indicator = palette.oniViolet;
            };
            focusedInactive = {
              border = palette.sumiInk6;
              childBorder = palette.sumiInk6;
              background = palette.sumiInk0;
              text = palette.oldWhite;
              indicator = palette.sumiInk6;
            };
            unfocused = {
              border = palette.sumiInk4;
              childBorder = palette.sumiInk4;
              background = palette.sumiInk0;
              text = palette.fujiGray;
              indicator = palette.sumiInk4;
            };
            urgent = {
              border = palette.waveRed;
              childBorder = palette.waveRed;
              background = palette.sumiInk3;
              text = palette.fujiWhite;
              indicator = palette.waveRed;
            };
          };

          bars = [
            {
              position = "top";
              fonts = {
                names = [ "Maple Mono NF" "Noto Sans CJK JP" ];
                size = 11.0;
              };
              colors = {
                background = palette.sumiInk0;
                statusline = palette.fujiWhite;
                separator = palette.sumiInk6;
                focusedWorkspace = {
                  border = palette.crystalBlue;
                  background = palette.crystalBlue;
                  text = palette.sumiInk0;
                };
                activeWorkspace = {
                  border = palette.waveBlue1;
                  background = palette.waveBlue1;
                  text = palette.fujiWhite;
                };
                inactiveWorkspace = {
                  border = palette.sumiInk0;
                  background = palette.sumiInk0;
                  text = palette.fujiGray;
                };
                urgentWorkspace = {
                  border = palette.waveRed;
                  background = palette.waveRed;
                  text = palette.sumiInk0;
                };
              };
            }
          ];
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
