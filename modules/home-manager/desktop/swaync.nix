# SwayNotificationCenter — notification daemon + slide-out control center
# Replaces mako: same toasts, plus a control center with mpris album art,
# volume/backlight sliders and a DND toggle (waybar bell icon).
# Symlinks ~/.config/swaync to the live-editable config in the repo
# (apply edits with `swaync-client --reload-config` / `--reload-css`).
#
# Per-host caveat: the backlight widget in config.json pins
# widget-config.backlight.device = "amdgpu_bl1". swaync's schema takes a literal
# device name (no glob, no autodetect) and defaults to "intel_backlight", which
# exists on neither host. Both hosts are amdgpu, but the bl index comes from DRM
# connector enumeration, so if the slider goes dead after a hardware/kernel
# change, check `ls /sys/class/backlight` and update that key.
{ config, lib, pkgs, ... }:

let
  cfg = config.modules.desktop.swaync;
in
{
  options.modules.desktop.swaync = {
    enable = lib.mkEnableOption "SwayNotificationCenter notification daemon";

    configDir = lib.mkOption {
      type = lib.types.str;
      default = "${config.home.homeDirectory}/nixos/home-manager-config-files/swaync";
      description = "Live-editable swaync config directory";
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages = [ pkgs.swaynotificationcenter ];

    xdg.configFile."swaync" = {
      source = config.lib.file.mkOutOfStoreSymlink cfg.configDir;
      # Overwrite pre-existing unmanaged files instead of aborting activation
      force = true;
    };

    systemd.user.services.swaync = {
      Unit = {
        Description = "Sway Notification Center";
        PartOf = [ "graphical-session.target" ];
        After = [ "graphical-session.target" ];
      };
      Service = {
        Type = "dbus";
        BusName = "org.freedesktop.Notifications";
        ExecStart = "${pkgs.swaynotificationcenter}/bin/swaync";
        ExecReload = "${pkgs.swaynotificationcenter}/bin/swaync-client --reload-config ; ${pkgs.swaynotificationcenter}/bin/swaync-client --reload-css";
        Restart = "on-failure";
      };
      Install.WantedBy = [ "graphical-session.target" ];
    };
  };
}
