# Yazi file manager configuration — Kanagawa flavor (Himal, docs/THEME.md)
{ config, lib, pkgs, inputs, ... }:

let
  cfg = config.modules.fileManagers.yazi;
in
{
  options.modules.fileManagers.yazi = {
    enable = lib.mkEnableOption "Yazi file manager";
  };

  config = lib.mkIf cfg.enable {
    # preview backends (pdftoppm, ffmpeg) come from hosts/common systemPackages

    programs.yazi = {
      enable = true;
      shellWrapperName = "y";
      enableZshIntegration = true;

      # pinned flake input (dangooddd/kanagawa.yazi) — was previously unthemed,
      # the one file manager outside the design system
      flavors.kanagawa = inputs.kanagawa-yazi;
      theme.flavor = {
        dark = "kanagawa";
        light = "kanagawa";
      };

      plugins.full-border = pkgs.yaziPlugins.full-border;
      initLua = ''
        require("full-border"):setup()
      '';

      settings.yazi = {
        opener = [
          {
            edit = {
              run = "nvim '$@'";
              block = true;
            };
          }
          {
            open = {
              run = "xdg-open '$@'";
              desc = "open";
            };
          }
          {
            # orphan: the player outlives yazi and doesn't grab its terminal
            play = {
              run = "mpv --force-window '$@'";
              orphan = true;
              desc = "play (mpv)";
            };
          }
        ];

        open = [
          {
            rules = [
              # media must match before the catch-all "*" → edit below,
              # or Enter on a video opens its bytes in nvim
              {
                mime = "video/*";
                use = "play";
              }
              {
                mime = "audio/*";
                use = "play";
              }
              {
                mime = "image/*";
                use = "open";
              }
              {
                mime = "text/plain";
                use = "edit";
              }
              {
                name = "*.txt";
                use = "edit";
              }
            ];
            append_rules = [
              {
                name = "*";
                use = "edit";
              }
            ];
          }
        ];
      };
    };
  };
}
