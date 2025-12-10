# User accounts configuration
{ config, lib, pkgs, ... }:

let
  cfg = config.modules.users;
in
{
  options.modules.users = {
    enable = lib.mkEnableOption "user configuration";

    username = lib.mkOption {
      type = lib.types.str;
      default = "hubert";
      description = "Primary username";
    };

    description = lib.mkOption {
      type = lib.types.str;
      default = "hubert";
      description = "User description/full name";
    };

    extraGroups = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [ "networkmanager" "wheel" "docker" "wireshark" "postgres" "video" ];
      description = "Extra groups for the user";
    };

    defaultShell = lib.mkOption {
      type = lib.types.package;
      default = pkgs.zsh;
      description = "Default shell for the user";
    };

    extraUserPackages = lib.mkOption {
      type = lib.types.listOf lib.types.package;
      default = with pkgs; [
        kdePackages.kate
      ];
      description = "Extra packages for the user";
    };
  };

  config = lib.mkIf cfg.enable {
    users.users.${cfg.username} = {
      isNormalUser = true;
      description = cfg.description;
      extraGroups = cfg.extraGroups;
      packages = cfg.extraUserPackages;
    };

    users.defaultUserShell = cfg.defaultShell;
  };
}
