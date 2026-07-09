# Ghostty terminal configuration — Kanagawa Wave (Ink & Wave design system)
# Colors are inlined (not a named theme) so they can't drift from docs/THEME.md.
{ config, lib, pkgs, ... }:

let
  cfg = config.modules.terminals.ghostty;
in
{
  options.modules.terminals.ghostty = {
    enable = lib.mkEnableOption "Ghostty terminal";

    fontFamily = lib.mkOption {
      type = lib.types.str;
      default = "Maple Mono NF";
      description = "Font family";
    };

    fontSize = lib.mkOption {
      type = lib.types.number;
      default = 14;
      description = "Font size";
    };

    backgroundOpacity = lib.mkOption {
      type = lib.types.number;
      default = 0.92;
      description = "Background opacity (0.0 - 1.0); hyprland blurs what shows through";
    };
  };

  config = lib.mkIf cfg.enable {
    programs.ghostty = {
      enable = true;
      installVimSyntax = true;
      installBatSyntax = true;
      settings = {
        "copy-on-select" = true;
        "font-family" = cfg.fontFamily;
        "font-size" = cfg.fontSize;
        # ligatures deliberately off (carried over from the JetBrainsMono setup)
        "font-feature" = "-calt,-liga,-dlig";
        "shell-integration" = "zsh";
        "background-opacity" = cfg.backgroundOpacity;
        "window-padding-x" = 8;
        "window-padding-y" = 6;

        # glowing kanagawa cursor trail (GLSL, GPU) — live-editable repo file
        "custom-shader" = "${config.home.homeDirectory}/nixos/dotfiles/ghostty/shaders/cursor_blaze.glsl";
        "custom-shader-animation" = true;

        # ── Kanagawa Wave ──
        "background" = "#1F1F28";
        "foreground" = "#DCD7BA";
        "cursor-color" = "#C8C093";
        "cursor-text" = "#1F1F28";
        "selection-background" = "#2D4F67";
        "selection-foreground" = "#C8C093";
        "palette" = [
          "0=#16161D"
          "1=#C34043"
          "2=#76946A"
          "3=#C0A36E"
          "4=#7E9CD8"
          "5=#957FB8"
          "6=#6A9589"
          "7=#C8C093"
          "8=#727169"
          "9=#E82424"
          "10=#98BB6C"
          "11=#E6C384"
          "12=#7FB4CA"
          "13=#938AA9"
          "14=#7AA89F"
          "15=#DCD7BA"
        ];
      };
    };
  };
}
