# SwayOSD — on-screen display for volume / brightness / caps-lock keys.
# hyprland.conf binds call swayosd-client (with wpctl/brightnessctl fallback
# so the keys keep working before the first rebuild).
{ config, lib, pkgs, ... }:

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
        background: alpha(#1F1F28, 0.95);
        border: 1px solid alpha(#54546D, 0.55);
        border-radius: 14px;
        padding: 12px 20px;
      }

      #container {
        margin: 14px;
      }

      image, label {
        color: #DCD7BA;
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
        background: #223249;
      }

      progress {
        min-height: 6px;
        border-radius: 999px;
        background: #7E9CD8;
      }
    '';
  };
}
