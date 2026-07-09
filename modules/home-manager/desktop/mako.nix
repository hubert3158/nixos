# Mako notification daemon configuration
# Symlinks ~/.config/mako to the live-editable config in the repo
# (apply edits with `makoctl reload`).
{ config, lib, pkgs, ... }:

let
  cfg = config.modules.desktop.mako;
in
{
  options.modules.desktop.mako = {
    enable = lib.mkEnableOption "Mako notification daemon";

    configDir = lib.mkOption {
      type = lib.types.str;
      default = "${config.home.homeDirectory}/nixos/home-manager-config-files/mako";
      description = "Live-editable mako config directory";
    };
  };

  config = lib.mkIf cfg.enable {
    xdg.configFile."mako" = {
      source = config.lib.file.mkOutOfStoreSymlink cfg.configDir;
      # Overwrite pre-existing unmanaged files instead of aborting activation
      force = true;
    };
  };
}
