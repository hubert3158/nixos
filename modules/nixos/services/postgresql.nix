# PostgreSQL database configuration
{ config, lib, pkgs, ... }:

let
  cfg = config.modules.services.postgresql;
in
{
  options.modules.services.postgresql = {
    enable = lib.mkEnableOption "PostgreSQL database server";

    package = lib.mkOption {
      type = lib.types.package;
      default = pkgs.postgresql_15;
      description = "PostgreSQL package to use";
    };

    listenAddresses = lib.mkOption {
      type = lib.types.str;
      default = "*";
      description = "Addresses to listen on";
    };

    enableRemoteAccess = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Allow remote connections via md5 authentication";
    };
  };

  config = lib.mkIf cfg.enable {
    services.postgresql = {
      enable = true;
      package = cfg.package;
      settings = {
        listen_addresses = lib.mkForce cfg.listenAddresses;
      };
      authentication = lib.mkIf cfg.enableRemoteAccess ''
        host all all 0.0.0.0/0 md5
      '';
    };

    environment.systemPackages = with pkgs; [
      pgformatter
      pgadmin4
    ];
  };
}
