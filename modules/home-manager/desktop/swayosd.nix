# SwayOSD — on-screen display for volume / brightness / caps-lock keys.
# hyprland.lua binds call swayosd-client (with wpctl/brightnessctl fallback
# so the keys keep working before the first rebuild).
{ config, lib, pkgs, palette, colors, ... }:

let
  cfg = config.modules.desktop.swayosd;
in
{
  options.modules.desktop.swayosd = {
    enable = lib.mkEnableOption "SwayOSD on-screen display";
  };

  config = lib.mkIf cfg.enable {
    services.swayosd = {
      enable = true;
      topMargin = 0.9; # bottom-ish, clear of waybar
    };

    # Kanagawa ink pill (docs/THEME.md) — swayosd reads ~/.config/swayosd/style.css
    xdg.configFile."swayosd/style.css".text = ''
      window#osd {
        background: alpha(${palette.sumiInk3}, 0.95);
        border: 1px solid alpha(${palette.sumiInk6}, 0.55);
        border-radius: 14px;
        padding: 12px 20px;
        box-shadow: 0 4px 16px ${colors.css palette.sumiInk0 "0.45"};
      }

      #container {
        margin: 14px;
      }

      image, label {
        color: ${palette.fujiWhite};
      }

      progressbar {
        min-height: 6px;
        border-radius: 999px;
        background: transparent;
        border: none;
      }

      trough {
        min-height: 6px;
        border-radius: 999px;
        background: ${palette.waveBlue1};
      }

      progress {
        min-height: 6px;
        border-radius: 999px;
        background: ${palette.crystalBlue};
      }

      /* muted state — the pill dims instead of staying accent-blue */
      window#osd.muted progress,
      window#osd image.muted {
        background: ${palette.sumiInk6};
        color: ${palette.fujiGray};
      }
    '';
  };
}
