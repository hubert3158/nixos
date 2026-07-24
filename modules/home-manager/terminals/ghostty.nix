# Ghostty terminal configuration — Kanagawa Wave (Ink & Wave design system)
# Colours come from lib/palette.nix rather than a named ghostty theme, so they
# can't drift from kitty.nix / wezterm.nix / docs/THEME.md.
{ config, lib, pkgs, palette, ... }:

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
        "window-padding-balance" = true;

        # same leading as kitty (modify_font cell_height 108%) so the two
        # terminals are typographically interchangeable
        "adjust-cell-height" = "8%";

        # a blinking cursor repaints its cell forever; the shader below is the
        # motion budget for this terminal
        "cursor-style-blink" = false;
        "mouse-hide-while-typing" = true;
        # unfocused splits recede — mirrors kitty's inactive_text_alpha and the
        # hyprland terminal-depth windowrule
        "unfocused-split-opacity" = 0.9;

        # glowing kanagawa cursor trail (GLSL, GPU) — live-editable repo file
        "custom-shader" = "${config.home.homeDirectory}/nixos/dotfiles/ghostty/shaders/cursor_blaze.glsl";
        "custom-shader-animation" = true;

        # ── Kanagawa Wave ──
        "background" = palette.sumiInk3;
        "foreground" = palette.fujiWhite;
        "cursor-color" = palette.oldWhite;
        "cursor-text" = palette.sumiInk3;
        "selection-background" = palette.waveBlue2;
        "selection-foreground" = palette.oldWhite;
        "palette" = [
          "0=${palette.sumiInk0}"
          "1=${palette.ansiRed}"
          "2=${palette.ansiGreen}"
          "3=${palette.ansiYellow}"
          "4=${palette.crystalBlue}"
          "5=${palette.oniViolet}"
          "6=${palette.ansiCyan}"
          "7=${palette.oldWhite}"
          "8=${palette.fujiGray}"
          "9=${palette.samuraiRed}"
          "10=${palette.springGreen}"
          "11=${palette.carpYellow}"
          "12=${palette.springBlue}"
          "13=${palette.springViolet1}"
          "14=${palette.waveAqua2}"
          "15=${palette.fujiWhite}"
        ];
      };
    };
  };
}
