# Fuzzel application launcher configuration
{ config, lib, pkgs, ... }:

let
  cfg = config.modules.desktop.fuzzel;
in
{
  options.modules.desktop.fuzzel = {
    enable = lib.mkEnableOption "Fuzzel application launcher";

    terminal = lib.mkOption {
      type = lib.types.str;
      default = "alacritty";
      description = "Terminal to use for terminal applications";
    };

    font = lib.mkOption {
      type = lib.types.str;
      default = "Monofur Nerd Font:size=24";
      description = "Font for fuzzel";
    };
  };

  config = lib.mkIf cfg.enable {
    programs.fuzzel = {
      enable = true;
      settings = {
        main = {
          terminal = cfg.terminal;
          layer = "overlay";
          font = cfg.font;
          icon-theme = "breeze";
          icons = true;
          fields = "name,generic,comment,categories,filename,keywords";
          width = 30;
          horizontal-pad = 40;
          vertical-pad = 8;
          inner-pad = 8;
        };

        colors = {
          background = "001d2ecc";
          text = "blanchedalmond";
          match = "mediumseagreen";
          selection = "000000cc";
          selection-text = "mediumseagreen";
          selection-match = "mediumseagreen";
          border = "001d2e";
        };

        border = {
          width = 1;
          radius = 0;
        };

        dmenu = {
          exit-immediately-if-empty = true;
        };

        key-bindings = {
          cancel = "Escape Control+c";
          execute = "Return KP_Enter Control+y";
          execute-or-next = "Tab";
          cursor-left = "Left Control+b";
          cursor-right = "Right Control+f";
          cursor-home = "Home Control+a";
          cursor-end = "End Control+e";
          delete-prev = "BackSpace";
          delete-next = "Delete";
          delete-prev-word = "Mod1+BackSpace Control+BackSpace";
          delete-next-word = "Mod1+d Control+Delete";
          prev = "Up Control+p";
          next = "Down Control+n";
          page-up = "Page_Up Control+v";
          page-down = "Page_Down Mod1+v";
        };
      };
    };
  };
}
