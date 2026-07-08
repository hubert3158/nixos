# Hyprlock configuration — Catppuccin Macchiato over a blurred desktop screenshot
{ config, lib, pkgs, ... }:

let
  cfg = config.modules.desktop.hyprlock;
in
{
  options.modules.desktop.hyprlock = {
    enable = lib.mkEnableOption "Hyprlock screen locker";

    gracePeriod = lib.mkOption {
      type = lib.types.int;
      default = 10;
      description = "Grace period before requiring password, in seconds";
    };
  };

  config = lib.mkIf cfg.enable {
    programs.hyprlock = {
      enable = true;
      settings = {
        general = {
          disable_loading_bar = true;
          grace = cfg.gracePeriod;
          hide_cursor = true;
          no_fade_in = false;
        };

        # frosted glass: whatever was on screen, heavily blurred
        background = [
          {
            monitor = "";
            path = "screenshot";
            blur_passes = 3;
            blur_size = 8;
            noise = 0.0117;
            brightness = 0.55;
          }
        ];

        label = [
          # big clock
          {
            monitor = "";
            text = "cmd[update:1000] date +'%H:%M'";
            font_family = "JetBrainsMono Nerd Font";
            font_size = 110;
            color = "rgb(202, 211, 245)";
            position = "0, 180";
            halign = "center";
            valign = "center";
            shadow_passes = 2;
          }
          # date
          {
            monitor = "";
            text = "cmd[update:60000] date +'%A, %d %B'";
            font_family = "JetBrainsMono Nerd Font";
            font_size = 22;
            color = "rgb(125, 196, 228)";
            position = "0, 80";
            halign = "center";
            valign = "center";
            shadow_passes = 2;
          }
          # user greeting
          {
            monitor = "";
            text = "󰌾  $USER";
            font_family = "JetBrainsMono Nerd Font";
            font_size = 15;
            color = "rgb(165, 173, 203)";
            position = "0, -160";
            halign = "center";
            valign = "center";
          }
        ];

        input-field = [
          {
            monitor = "";
            size = "300, 55";
            position = "0, -80";
            rounding = 14;
            outline_thickness = 2;
            dots_size = 0.28;
            dots_spacing = 0.3;
            dots_center = true;
            fade_on_empty = false;
            font_family = "JetBrainsMono Nerd Font";
            font_color = "rgb(202, 211, 245)";
            inner_color = "rgba(30, 32, 48, 0.85)";
            outer_color = "rgb(125, 196, 228)";
            check_color = "rgb(238, 212, 159)";
            fail_color = "rgb(237, 135, 150)";
            fail_text = "<i>wrong ($ATTEMPTS)</i>";
            placeholder_text = "<span foreground='##6e738d'>password…</span>";
            shadow_passes = 2;
          }
        ];
      };
    };
  };
}
