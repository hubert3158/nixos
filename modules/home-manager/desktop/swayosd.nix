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
  };
}
