# Hypridle — idle daemon: lock screen, then display off. No auto-suspend
# (dev machine runs docker/long jobs). Waybar's caffeine (idle_inhibitor)
# and fullscreen windows both inhibit these timeouts.
{ config, lib, pkgs, ... }:

let
  cfg = config.modules.desktop.hypridle;
in
{
  options.modules.desktop.hypridle = {
    enable = lib.mkEnableOption "Hypridle idle daemon";

    lockTimeout = lib.mkOption {
      type = lib.types.int;
      default = 600;
      description = "Seconds of idle before locking";
    };

    dpmsTimeout = lib.mkOption {
      type = lib.types.int;
      default = 780;
      description = "Seconds of idle before turning displays off";
    };
  };

  config = lib.mkIf cfg.enable {
    services.hypridle = {
      enable = true;
      settings = {
        general = {
          # hyprlock 0.9.5: grace is a CLI flag now (general:grace was removed);
          # auto-lock gets a 10s mouse-move grace, manual lock (wlogout) doesn't
          lock_cmd = "pidof hyprlock || hyprlock --grace 10"; # never spawn a second locker
          before_sleep_cmd = "loginctl lock-session"; # lock before suspend
          after_sleep_cmd = "hyprctl dispatch dpms on";
        };

        listener = [
          {
            timeout = cfg.lockTimeout;
            on-timeout = "loginctl lock-session";
          }
          {
            timeout = cfg.dpmsTimeout;
            on-timeout = "hyprctl dispatch dpms off";
            on-resume = "hyprctl dispatch dpms on";
          }
        ];
      };
    };
  };
}
