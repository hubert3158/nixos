# Fuzzel application launcher — Ink & Wave (lib/palette.nix, docs/THEME.md)
{ config, lib, pkgs, palette, colors, ... }:

let
  cfg = config.modules.desktop.fuzzel;
  # aliased: the fuzzel settings block has its own `colors` attribute
  ink = colors;
in
{
  options.modules.desktop.fuzzel = {
    enable = lib.mkEnableOption "Fuzzel application launcher";

    terminal = lib.mkOption {
      type = lib.types.str;
      # must be a terminal that is actually installed — fuzzel spawns this for
      # any Terminal=true desktop entry, and silently does nothing if it's
      # missing. (Was "alacritty", which this config has never installed.)
      default = "kitty";
      description = "Terminal used to launch Terminal=true desktop entries";
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

        # Kanagawa Ink & Wave — matches waybar/hyprland/swaync (docs/THEME.md).
        # fuzzel takes bare RRGGBBAA, no '#'.
        colors = {
          background = ink.fuzzel palette.sumiInk3 "e6";
          text = ink.fuzzel palette.fujiWhite "ff";
          placeholder = ink.fuzzel palette.fujiGray "ff";
          prompt = ink.fuzzel palette.crystalBlue "ff";
          input = ink.fuzzel palette.fujiWhite "ff";
          match = ink.fuzzel palette.carpYellow "ff";
          selection = ink.fuzzel palette.waveBlue1 "ff";
          selection-text = ink.fuzzel palette.fujiWhite "ff";
          selection-match = ink.fuzzel palette.carpYellow "ff";
          counter = ink.fuzzel palette.fujiGray "ff";
          border = ink.fuzzel palette.crystalBlue "ee";
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
