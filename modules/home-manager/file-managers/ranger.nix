# Ranger file manager configuration
{ config, lib, pkgs, ... }:

let
  cfg = config.modules.fileManagers.ranger;
in
{
  options.modules.fileManagers.ranger = {
    enable = lib.mkEnableOption "Ranger file manager";

    colorscheme = lib.mkOption {
      type = lib.types.str;
      default = "solarized";
      description = "Ranger colorscheme";
    };
  };

  config = lib.mkIf cfg.enable {
    programs.ranger = {
      enable = true;
      extraConfig = ''
        set colorscheme ${cfg.colorscheme}
      '';
      rifle = [
        {
          command = "${config.home.profileDirectory}/bin/nvim -- \"$@\"";
          condition = "mime ^text";
        }
        {
          command = "${config.home.profileDirectory}/bin/swayimg -- \"$@\"";
          condition = "mime ^image";
        }
        {
          command = "${config.home.profileDirectory}/bin/microsoft-edge -- \"$@\"";
          condition = "mime ^pdf";
        }
      ];
    };
  };
}
