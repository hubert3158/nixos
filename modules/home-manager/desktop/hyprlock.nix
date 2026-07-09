# Hyprlock configuration — Kanagawa ink over a blurred desktop screenshot
# (Ink & Wave design system, docs/THEME.md)
{ config, lib, pkgs, ... }:

let
  cfg = config.modules.desktop.hyprlock;

  # playerctl's {{ }} template braces are eaten by hyprlang's inline math
  # parser ("Invalid expression type") — the label's text then silently falls
  # back to hyprlock's built-in default, which is literally "Sample Text".
  # Keeping the braces inside a script keeps hyprlang away from them.
  nowPlaying = pkgs.writeShellScript "hyprlock-now-playing" ''
    ${pkgs.playerctl}/bin/playerctl metadata --format '󰎆  {{ title }} — {{ artist }}' 2>/dev/null | head -c 80 || true
  '';
in
{
  options.modules.desktop.hyprlock = {
    enable = lib.mkEnableOption "Hyprlock screen locker";
  };

  config = lib.mkIf cfg.enable {
    programs.hyprlock = {
      enable = true;
      settings = {
        # NOTE hyprlock 0.9.5: general:{disable_loading_bar,grace,no_fade_in}
        # were removed — grace moved to the CLI (`hyprlock --grace N`, wired in
        # hypridle.nix); fade is animations:enabled (on by default).
        general = {
          hide_cursor = true;
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
          # big clock — fujiWhite ink
          {
            monitor = "";
            text = "cmd[update:1000] date +'%H:%M'";
            font_family = "Maple Mono NF";
            font_size = 110;
            color = "rgb(220, 215, 186)";
            position = "0, 180";
            halign = "center";
            valign = "center";
            shadow_passes = 2;
          }
          # date — springBlue
          {
            monitor = "";
            text = "cmd[update:60000] date +'%A, %d %B'";
            font_family = "Maple Mono NF";
            font_size = 22;
            color = "rgb(127, 180, 202)";
            position = "0, 80";
            halign = "center";
            valign = "center";
            shadow_passes = 2;
          }
          # 「波に乗れ」 — ride the wave
          {
            monitor = "";
            text = "「 波 に 乗 れ 」";
            font_family = "Noto Sans CJK JP";
            font_size = 14;
            color = "rgb(114, 113, 105)";
            position = "0, 40";
            halign = "center";
            valign = "center";
          }
          # user greeting — oldWhite
          {
            monitor = "";
            text = "󰌾  $USER";
            font_family = "Maple Mono NF";
            font_size = 15;
            color = "rgb(200, 192, 147)";
            position = "0, -160";
            halign = "center";
            valign = "center";
          }
          # now playing — waveAqua, empty when nothing plays
          {
            monitor = "";
            text = "cmd[update:2000] ${nowPlaying}";
            font_family = "Maple Mono NF";
            font_size = 13;
            color = "rgb(122, 168, 159)";
            position = "0, -210";
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
            font_family = "Maple Mono NF";
            font_color = "rgb(220, 215, 186)";
            inner_color = "rgba(31, 31, 40, 0.85)";
            outer_color = "rgb(126, 156, 216)";
            check_color = "rgb(230, 195, 132)";
            fail_color = "rgb(255, 93, 98)";
            fail_text = "<i>wrong ($ATTEMPTS)</i>";
            placeholder_text = "<span foreground='##727169'>password…</span>";
            shadow_passes = 2;
          }
        ];
      };
    };
  };
}
