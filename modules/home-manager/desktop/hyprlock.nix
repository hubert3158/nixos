# Hyprlock configuration — Kanagawa ink over a blurred desktop screenshot
# (Himal design system, docs/THEME.md).
# Colours come from lib/palette.nix via `colors.hypr` — hyprlang accepts
# rgb(RRGGBB), so the decimal rgb(220, 215, 186) triples this file used to
# carry (unsearchable, un-lintable) are gone.
{ config, lib, pkgs, palette, colors, ... }:

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
            color = colors.hypr palette.fujiWhite;
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
            color = colors.hypr palette.springBlue;
            position = "0, 80";
            halign = "center";
            valign = "center";
            shadow_passes = 2;
          }
          # ukalo — the climb
          {
            monitor = "";
            text = "॥ उ का लो ॥";
            font_family = "Noto Sans CJK JP";
            font_size = 14;
            color = colors.hypr palette.fujiGray;
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
            color = colors.hypr palette.oldWhite;
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
            color = colors.hypr palette.waveAqua2;
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
            font_color = colors.hypr palette.fujiWhite;
            inner_color = colors.hyprA palette.sumiInk3 "d9"; # 0.85 alpha
            outer_color = colors.hypr palette.crystalBlue;
            check_color = colors.hypr palette.carpYellow;
            fail_color = colors.hypr palette.peachRed;
            fail_text = "<i>wrong ($ATTEMPTS)</i>";
            # pango markup inside hyprlang: a literal '#' must be written '##',
            # otherwise hyprlang treats the rest of the line as a comment
            placeholder_text = "<span foreground='##${colors.bare palette.fujiGray}'>password…</span>";
            shadow_passes = 2;
          }
        ];
      };
    };
  };
}
