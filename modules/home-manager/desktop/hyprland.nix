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

        # cursor tilt + shake-to-find. nixpkgs pins this at f5ba36c
        # (2026-07-21), which predates Hyprland 0.56.2 (2026-08-05). It still
        # compiles, but the plugin resolves Hyprland internals by function
        # signature at init, so 0.56 makes it throw and Hyprland paints a red
        # error overlay across the top of the screen:
        #   [dynamic-cursors] cannot load, unexpected function signature
        #   ... plugin crashed/threw in main: std::exception
        # The rev below is the one upstream's own hyprpm.toml pins to Hyprland
        # v0.56.2 (commit efb5099). Do NOT use the plugin's HEAD instead: it
        # tracks Hyprland git main, which moved the IPC to
        # hyprland/src/ipc/s2/S2.hpp — a header 0.56.2 does not ship, so it
        # fails to compile. Drop this override once nixpkgs ships a rev at or
        # past this one.
        (pkgs.hyprlandPlugins.hypr-dynamic-cursors.overrideAttrs (_: {
          version = "0-unstable-2026-08-03";
          src = pkgs.fetchFromGitHub {
            owner = "VirtCode";
            repo = "hypr-dynamic-cursors";
            rev = "5a224284872208b5324759d535d65061043725de";
            hash = "sha256-BQjuQplkQFA30/7evDxmEAvr2ArIG09JffEBQhuzo80=";
          };
        }))
      ];
      # require() with an absolute path registers the dotfile with Hyprland's
      # inotify watcher (plain dofile() would not), so saving it reloads live.
      extraConfig = ''require("${cfg.configFile}")'';
    };
  };
}
