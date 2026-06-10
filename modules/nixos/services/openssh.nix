# OpenSSH daemon configuration
{ config, lib, pkgs, ... }:

let
  cfg = config.modules.services.openssh;
in
{
  options.modules.services.openssh = {
    enable = lib.mkEnableOption "OpenSSH daemon";

    permitRootLogin = lib.mkOption {
      type = lib.types.str;
      default = "prohibit-password";
      description = "Root login policy";
    };

    passwordAuthentication = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Allow password authentication (key-only by default; verify ~/.ssh/authorized_keys before enabling sshd on a new machine)";
    };
  };

  config = lib.mkIf cfg.enable {
    services.openssh = {
      enable = true;
      settings = {
        PermitRootLogin = cfg.permitRootLogin;
        PasswordAuthentication = cfg.passwordAuthentication;
      };
    };
  };
}
