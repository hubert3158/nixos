# Wlogout — full-screen power menu (Ink & Wave design system)
# Six frosted ink cards over the blurred desktop (hyprland layerrule blurs
# the logout_dialog namespace). Launch: `wlogout -b 3 --protocol layer-shell`.
{ config, lib, pkgs, ... }:

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
          action = "hyprctl dispatch exit";
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
          background-color: rgba(22, 22, 29, 0.55);
        }

        button {
          background-color: rgba(31, 31, 40, 0.92);
          color: #DCD7BA;
          border: 1px solid rgba(84, 84, 109, 0.55);
          border-radius: 16px;
          margin: 12px;
          font-size: 20px;
          box-shadow: 0 6px 20px rgba(22, 22, 29, 0.55);
        }

        button:focus,
        button:active,
        button:hover {
          background-color: rgba(126, 156, 216, 0.95); /* crystalBlue */
          color: #16161D;
          border-color: #7E9CD8;
        }

        #shutdown:focus,
        #shutdown:active,
        #shutdown:hover {
          background-color: rgba(255, 93, 98, 0.95); /* peachRed */
          border-color: #FF5D62;
        }

        #reboot:focus,
        #reboot:active,
        #reboot:hover {
          background-color: rgba(230, 195, 132, 0.95); /* carpYellow */
          border-color: #E6C384;
        }
      '';
    };
  };
}
