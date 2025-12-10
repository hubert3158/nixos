# Yazi file manager configuration
{ config, lib, pkgs, ... }:

let
  cfg = config.modules.fileManagers.yazi;
in
{
  options.modules.fileManagers.yazi = {
    enable = lib.mkEnableOption "Yazi file manager";
  };

  config = lib.mkIf cfg.enable {
    programs.yazi = {
      enable = true;
      enableZshIntegration = true;
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
        ];

        open = [
          {
            rules = [
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
