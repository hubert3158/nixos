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
  };
}
