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
      default = "${config.home.homeDirectory}/nixos/dotfiles/hypr/hyprland.lua";
      description = "Path to external Hyprland Lua config file";
    };
  };

  config = lib.mkIf cfg.enable {
    wayland.windowManager.hyprland = {
      enable = true;
      # Lua, not hyprlang: Hyprland 0.56 deprecated the .conf format and drops
      # it in 0.57. Home Manager writes ~/.config/hypr/hyprland.lua (plus a
      # .luarc.json pointing lua-ls at the stubs shipped with the package).
      configType = "lua";
      xwayland.enable = cfg.enableXwayland;
      # Disable systemd integration as it conflicts with uwsm
      systemd.enable = false;
      # Plugins are loaded before extraConfig sources the dotfile, so the
      # plugin{} block and overview binds there resolve correctly.
      plugins = [
        # hyprspace (workspace overview, Mod+grave) is disabled: Hyprland 0.56
        # moved src/managers/animation/AnimationManager.hpp to
        # src/animation/AnimationManager.hpp and upstream Hyprspace (pinned in
        # nixpkgs at c109256, 2026-05-28) still includes the old path, so the
        # plugin no longer compiles. Re-enable once nixpkgs ships a rev that
        # builds against 0.56 (PR KZDKM/Hyprspace#238 is the candidate).
        # pkgs.hyprlandPlugins.hyprspace
        pkgs.hyprlandPlugins.hypr-dynamic-cursors # cursor tilt + shake-to-find
      ];
      # require() with an absolute path registers the dotfile with Hyprland's
      # inotify watcher (plain dofile() would not), so saving it reloads live.
      extraConfig = ''require("${cfg.configFile}")'';
    };
  };
}
