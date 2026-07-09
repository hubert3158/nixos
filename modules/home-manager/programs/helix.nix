# Helix editor configuration
{ config, lib, pkgs, ... }:

let
  cfg = config.modules.programs.helix;
in
{
  options.modules.programs.helix = {
    enable = lib.mkEnableOption "Helix editor";

    theme = lib.mkOption {
      type = lib.types.str;
      default = "kanagawa";
      description = "Color theme (built-ins: kanagawa, catppuccin_mocha, tokyonight_storm, gruvbox, onedark)";
    };
  };

  config = lib.mkIf cfg.enable {
    programs.helix = {
      enable = true;

      settings = {
        theme = cfg.theme;

        editor = {
          line-number = "relative";
          cursorline = true;
          color-modes = true;
          true-color = true;
          bufferline = "multiple";
          rulers = [ 100 ];
          idle-timeout = 50;
          completion-trigger-len = 1;

          cursor-shape = {
            normal = "block";
            insert = "bar";
            select = "underline";
          };

          indent-guides = {
            render = true;
            character = "▏";
            skip-levels = 1;
          };

          statusline = {
            left = [ "mode" "spinner" "version-control" "file-name" "file-modification-indicator" ];
            right = [ "diagnostics" "selections" "position" "file-encoding" "file-type" ];
            mode = {
              normal = "NOR";
              insert = "INS";
              select = "SEL";
            };
          };

          lsp = {
            display-messages = true;
            display-inlay-hints = true;
          };

          file-picker = {
            hidden = false; # show dotfiles in file picker
          };

          whitespace.render = {
            space = "none";
            tab = "all";
            newline = "none";
          };

          soft-wrap = {
            enable = true;
            wrap-indicator = "↪ ";
          };
        };

        keys.normal = {
          # Quick save / quit
          space.w = ":write";
          space.q = ":quit";
          # Clear search highlight
          esc = [ "collapse_selection" "keep_primary_selection" ];
        };
      };
    };
  };
}
