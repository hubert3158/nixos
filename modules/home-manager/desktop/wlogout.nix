# Wlogout — full-screen power menu (Himal design system)
# Six frosted ink cards over the blurred desktop (hyprland layerrule blurs
# the logout_dialog namespace). Launch: `wlogout -b 3 --protocol layer-shell`.
{ config, lib, pkgs, palette, colors, ... }:

let
  cfg = config.modules.desktop.wlogout;
in
{
  options.modules.desktop.wlogout = {
    enable = lib.mkEnableOption "Wlogout power menu";
  };

  config = lib.mkIf cfg.enable {
    programs.wlogout = {
      enable = true;

      layout = [
        {
          label = "lock";
          action = "hyprlock";
          text = "󰌾   Lock";
          keybind = "l";
        }
        {
          label = "logout";
          # Lua config manager: `hyprctl dispatch` wraps hl.dispatch(...), so
          # the argument is a Lua dispatcher rather than the old `exit` keyword.
          action = "hyprctl dispatch 'hl.dsp.exit()'";
          text = "󰍃   Logout";
          keybind = "e";
        }
        {
          label = "suspend";
          action = "systemctl suspend";
          text = "󰒲   Suspend";
          keybind = "s";
        }
        {
          label = "hibernate";
          action = "systemctl hibernate";
          text = "󰋊   Hibernate";
          keybind = "h";
        }
        {
          label = "reboot";
          action = "systemctl reboot";
          text = "󰜉   Reboot";
          keybind = "r";
        }
        {
          label = "shutdown";
          action = "systemctl poweroff";
          text = "󰐥   Shutdown";
          keybind = "p";
        }
      ];

      style = ''
        * {
          background-image: none;
          font-family: "Maple Mono NF", "JetBrainsMono Nerd Font", sans-serif;
        }

        window {
          background-color: ${colors.css palette.sumiInk0 "0.55"};
        }

        button {
          background-color: ${colors.css palette.sumiInk3 "0.92"};
          color: ${palette.fujiWhite};
          border: 1px solid ${colors.css palette.sumiInk6 "0.55"};
          border-radius: 16px;
          margin: 12px;
          font-size: 20px;
          box-shadow: 0 6px 20px ${colors.css palette.sumiInk0 "0.55"};
          transition: background-color 200ms cubic-bezier(0.05, 0.7, 0.1, 1),
                      border-color 200ms cubic-bezier(0.05, 0.7, 0.1, 1);
        }

        button:focus,
        button:active,
        button:hover {
          background-color: ${colors.css palette.crystalBlue "0.95"};
          color: ${palette.sumiInk0};
          border-color: ${palette.crystalBlue};
        }

        #shutdown:focus,
        #shutdown:active,
        #shutdown:hover {
          background-color: ${colors.css palette.peachRed "0.95"};
          border-color: ${palette.peachRed};
        }

        #reboot:focus,
        #reboot:active,
        #reboot:hover {
          background-color: ${colors.css palette.carpYellow "0.95"};
          border-color: ${palette.carpYellow};
        }

        #lock:focus,
        #lock:active,
        #lock:hover {
          background-color: ${colors.css palette.springBlue "0.95"};
          border-color: ${palette.springBlue};
        }

        #suspend:focus,
        #suspend:active,
        #suspend:hover,
        #hibernate:focus,
        #hibernate:active,
        #hibernate:hover {
          background-color: ${colors.css palette.oniViolet "0.95"};
          border-color: ${palette.oniViolet};
        }

        #logout:focus,
        #logout:active,
        #logout:hover {
          background-color: ${colors.css palette.waveAqua2 "0.95"};
          border-color: ${palette.waveAqua2};
        }
      '';
    };
  };
}
