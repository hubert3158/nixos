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
      default = "Maple Mono NF:size=14";
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
          prompt = "\"❯ \"";
          icon-theme = "Papirus-Dark";
          icons = true;
          fields = "name,generic,comment,categories,filename,keywords";
          width = 34;
          lines = 12;
          horizontal-pad = 24;
          vertical-pad = 16;
          inner-pad = 10;
        };

        # Kanagawa Ink & Wave — matches waybar/hyprland/swaync (docs/THEME.md)
        colors = {
          background = "1f1f28e6";
          text = "dcd7baff";
          placeholder = "727169ff";
          prompt = "7e9cd8ff";
          input = "dcd7baff";
          match = "e6c384ff";
          selection = "223249ff";
          selection-text = "dcd7baff";
          selection-match = "e6c384ff";
          counter = "727169ff";
          border = "7e9cd8ee";
        };

        border = {
          width = 2;
          radius = 12;
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
