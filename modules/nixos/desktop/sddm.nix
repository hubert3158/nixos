# SDDM Display Manager configuration — astronaut theme (japanese_aesthetic)
# Animated Japanese login screen; part of the Ink & Wave design system
# (docs/THEME.md). Theme variants: astronaut, japanese_aesthetic, pixel_sakura,
# black_hole, purple_leaves, ... — switch via the `themeVariant` option.
{ config, lib, pkgs, ... }:

let
  cfg = config.modules.desktop.sddm;

  astronautTheme = pkgs.sddm-astronaut.override {
    embeddedTheme = cfg.themeVariant;
  };
in
{
  options.modules.desktop.sddm = {
    enable = lib.mkEnableOption "SDDM display manager";

    enableXserver = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Enable X server alongside SDDM";
    };

    xkbLayout = lib.mkOption {
      type = lib.types.str;
      default = "us";
      description = "Keyboard layout";
    };

    xkbVariant = lib.mkOption {
      type = lib.types.str;
      default = "";
      description = "Keyboard variant";
    };

    themeVariant = lib.mkOption {
      type = lib.types.str;
      default = "japanese_aesthetic";
      description = "sddm-astronaut embedded theme variant";
    };
  };

  config = lib.mkIf cfg.enable {
    services.displayManager.sddm = {
      enable = true;
      # astronaut theme is Qt6 QML — needs the kdePackages (qt6) sddm build
      package = pkgs.kdePackages.sddm;
      theme = "sddm-astronaut-theme";
      extraPackages = with pkgs.kdePackages; [
        qtmultimedia # animated (video) theme backgrounds
        qtsvg
        qtvirtualkeyboard
      ];
    };

    environment.systemPackages = [ astronautTheme ];

    services.xserver = {
      enable = cfg.enableXserver;
      xkb.layout = cfg.xkbLayout;
      xkb.variant = cfg.xkbVariant;
    };

    # Enable envfs for compatibility
    services.envfs.enable = true;
  };
}
