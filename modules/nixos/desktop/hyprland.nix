# Hyprland compositor configuration
{ config, lib, pkgs, ... }:

let
  cfg = config.modules.desktop.hyprland;
in
{
  options.modules.desktop.hyprland = {
    enable = lib.mkEnableOption "Hyprland compositor";

    withUWSM = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Enable UWSM integration for better systemd support";
    };
  };

  config = lib.mkIf cfg.enable {
    programs.hyprland = {
      enable = true;
      withUWSM = cfg.withUWSM;
    };

    # XDG Portal for Wayland
    xdg.portal = {
      enable = true;
      extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
    };

    # Enable DBus
    services.dbus.enable = true;

    # Session variables for Wayland
    environment.sessionVariables = {
      NIXOS_OZONE_WL = "1"; # Hint electron apps to use wayland
      XDG_CURRENT_DESKTOP = "Hyprland";
    };

    # Required packages for Hyprland
    environment.systemPackages = with pkgs; [
      # Wayland essentials
      wayland
      wayland-protocols
      wl-clipboard
      xwayland
      egl-wayland

      # XDG portals
      xdg-desktop-portal
      xdg-desktop-portal-wlr

      # Hyprland utilities
      hyprland
      hyprlock

      # NOTE: retired cruft removed — hyprpaper/swaybg (awww owns wallpapers),
      # swayidle/swaylock (hypridle/hyprlock own idle+lock), mako (swaync owns
      # notifications; two daemons would fight over org.freedesktop.Notifications),
      # dmenu (fuzzel dmenu mode)

      # Screenshot tools
      grim
      slurp

      # Clipboard
      cliphist

      # Application launcher
      fuzzel

      # Bar
      waybar
    ];
  };
}
