# Waybar status bar configuration
# Symlinks ~/.config/waybar to the live-editable config in the repo
# (style reloads on save; config changes need a waybar restart).
{ config, lib, pkgs, ... }:

let
  cfg = config.modules.desktop.waybar;
in
{
  options.modules.desktop.waybar = {
    enable = lib.mkEnableOption "Waybar status bar";

    configDir = lib.mkOption {
      type = lib.types.str;
      default = "${config.home.homeDirectory}/nixos/home-manager-config-files/waybar";
      description = "Live-editable waybar config directory";
    };
  };

  config = lib.mkIf cfg.enable {
    xdg.configFile."waybar" = {
      source = config.lib.file.mkOutOfStoreSymlink cfg.configDir;
      # Overwrite pre-existing unmanaged files instead of aborting activation
      force = true;
    };

    # Supervised rather than `exec-once = waybar` in hyprland.lua: the mpris
    # module segfaults inside playerctl_player_properties_changed_callback when
    # a player drops its D-Bus name (crashes on 2026-08-07 and 2026-08-12), and
    # an exec-once bar never comes back — the desktop stays bare until the next
    # login. Restart=always brings it back in ~2s. Started by uwsm's
    # graphical-session.target, same as swaync/awww-daemon.
    systemd.user.services.waybar = {
      Unit = {
        Description = "Waybar status bar";
        PartOf = [ "graphical-session.target" ];
        After = [ "graphical-session.target" ];
      };
      Service = {
        ExecStart = "${pkgs.waybar}/bin/waybar";
        # SIGUSR2 makes waybar re-read config + style without dropping the bar
        ExecReload = "${pkgs.coreutils}/bin/kill -SIGUSR2 $MAINPID";
        Restart = "always";
        RestartSec = 2;
      };
      Install.WantedBy = [ "graphical-session.target" ];
    };
  };
}
