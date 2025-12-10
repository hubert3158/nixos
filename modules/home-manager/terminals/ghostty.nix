# Ghostty terminal configuration
{ config, lib, pkgs, ... }:

let
  cfg = config.modules.terminals.ghostty;
in
{
  options.modules.terminals.ghostty = {
    enable = lib.mkEnableOption "Ghostty terminal";

    fontFamily = lib.mkOption {
      type = lib.types.str;
      default = "monofur nerd font";
      description = "Font family";
    };

    fontSize = lib.mkOption {
      type = lib.types.number;
      default = 18;
      description = "Font size";
    };

    theme = lib.mkOption {
      type = lib.types.str;
      default = "Arthur";
      description = "Color theme";
    };

    backgroundOpacity = lib.mkOption {
      type = lib.types.number;
      default = 0.9;
      description = "Background opacity (0.0 - 1.0)";
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
        "font-size " = cfg.fontSize;
        "font-style" = "light";
        "font-feature" = "-calt,-liga,-dlig";
        "font-style-bold" = "false";
        "shell-integration" = "fish";
        "theme" = cfg.theme;
        "background-opacity" = cfg.backgroundOpacity;
      };
    };
  };
}
