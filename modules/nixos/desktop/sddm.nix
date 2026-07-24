# SDDM Display Manager configuration — astronaut theme (japanese_aesthetic)
# Animated Japanese login screen; part of the Ink & Wave design system
# (docs/THEME.md). Theme variants: astronaut, japanese_aesthetic, pixel_sakura,
# black_hole, purple_leaves, ... — switch via the `themeVariant` option.
#
# The theme's own chrome ships Gruvbox-ish greys over a Dracula-ish panel,
# which made the login screen the second surface — after the boot splash —
# that didn't match the rest of the machine. `themeConfig` writes a
# <variant>.conf.user that SDDM layers over the theme defaults, so every colour
# below comes from lib/palette.nix while the theme keeps its artwork.
{ config, lib, pkgs, palette, ... }:

let
  cfg = config.modules.desktop.sddm;

  astronautTheme = pkgs.sddm-astronaut.override {
    embeddedTheme = cfg.themeVariant;
    themeConfig = {
      # ── type ──
      Font = "Maple Mono NF";
      HeaderText = "「 波 に 乗 れ 」";
      RoundCorners = 12; # shell radius from docs/THEME.md

      # ── push the artwork back so the ink chrome reads on top of it ──
      DimBackground = "0.35";
      DimBackgroundColor = palette.sumiInk0;
      BackgroundColor = palette.sumiInk0;
      FormBackgroundColor = palette.sumiInk3;

      # ── clock / header ──
      HeaderTextColor = palette.fujiWhite;
      DateTextColor = palette.oldWhite;
      TimeTextColor = palette.fujiWhite;

      # ── input fields ──
      LoginFieldBackgroundColor = palette.sumiInk4;
      PasswordFieldBackgroundColor = palette.sumiInk4;
      LoginFieldTextColor = palette.fujiWhite;
      PasswordFieldTextColor = palette.fujiWhite;
      PlaceholderTextColor = palette.fujiGray;
      UserIconColor = palette.crystalBlue;
      PasswordIconColor = palette.crystalBlue;
      WarningColor = palette.peachRed;

      # ── login button: the crystalBlue accent, same as every other focus ──
      LoginButtonTextColor = palette.sumiInk0;
      LoginButtonBackgroundColor = palette.crystalBlue;

      # ── system / session chrome ──
      SystemButtonsIconsColor = palette.oldWhite;
      SessionButtonTextColor = palette.oldWhite;
      VirtualKeyboardButtonTextColor = palette.oldWhite;

      DropdownTextColor = palette.fujiWhite;
      DropdownBackgroundColor = palette.sumiInk2;
      DropdownSelectedBackgroundColor = palette.waveBlue1;

      HighlightTextColor = palette.sumiInk0;
      HighlightBackgroundColor = palette.crystalBlue;
      HighlightBorderColor = "transparent";

      # hover lifts to the secondary accent
      HoverUserIconColor = palette.springBlue;
      HoverPasswordIconColor = palette.springBlue;
      HoverSystemButtonsIconsColor = palette.springBlue;
      HoverSessionButtonTextColor = palette.springBlue;
      HoverVirtualKeyboardButtonTextColor = palette.springBlue;
    };
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
