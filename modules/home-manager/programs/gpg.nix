# GPG agent configuration
{ config, lib, pkgs, ... }:

let
  cfg = config.modules.programs.gpg;
in
{
  options.modules.programs.gpg = {
    enable = lib.mkEnableOption "GPG agent configuration";

    enableSshSupport = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Enable SSH support in GPG agent";
    };

    enableZshIntegration = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Enable Zsh integration";
    };
  };

  config = lib.mkIf cfg.enable {
    services.gpg-agent = {
      enable = true;
      enableZshIntegration = cfg.enableZshIntegration;
      enableSshSupport = cfg.enableSshSupport;
      pinentry.package = pkgs.pinentry-gnome3;
    };

    services.gnome-keyring = {
      enable = true;
      components = [ "secrets" ];
    };
  };
}
