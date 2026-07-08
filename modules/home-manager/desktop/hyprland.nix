# Hyprland user configuration
{ config, lib, pkgs, ... }:

let
  cfg = config.modules.desktop.hyprland;
in
{
  options.modules.desktop.hyprland = {
    enable = lib.mkEnableOption "Hyprland user configuration";

    enableXwayland = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Enable XWayland support";
    };

    configFile = lib.mkOption {
      type = lib.types.str;
      default = "${config.home.homeDirectory}/nixos/dotfiles/hypr/hyprland.conf";
      description = "Path to external Hyprland config file";
    };
  };

  config = lib.mkIf cfg.enable {
    wayland.windowManager.hyprland = {
      enable = true;
      configType = "hyprlang";
      xwayland.enable = cfg.enableXwayland;
      # Disable systemd integration as it conflicts with uwsm
      systemd.enable = false;
      # Plugins are loaded before extraConfig sources the dotfile, so the
      # plugin{} block and overview binds there resolve correctly.
      plugins = [
        pkgs.hyprlandPlugins.hyprspace # workspace overview (Mod+grave)
        pkgs.hyprlandPlugins.hypr-dynamic-cursors # cursor tilt + shake-to-find
      ];
      extraConfig = ''source = ${cfg.configFile} '';
    };
  };
}
