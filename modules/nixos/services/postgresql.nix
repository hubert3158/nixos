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
      # Do NOT bump to 16/17 casually: a major-version upgrade requires
      # pg_upgrade / dump-restore of the existing data dir under
      # /var/lib/postgresql, or the service refuses to start.
      default = pkgs.postgresql_15;
      description = "PostgreSQL package to use";
    };

    listenAddresses = lib.mkOption {
      type = lib.types.str;
      default = "127.0.0.1";
      description = "Addresses to listen on (localhost only by default — this laptop joins untrusted networks)";
    };
  };

  config = lib.mkIf cfg.enable {
    services.postgresql = {
      enable = true;
      package = cfg.package;
      settings = {
        listen_addresses = lib.mkForce cfg.listenAddresses;
      };
      # NixOS default pg_hba covers local peer + 127.0.0.1/::1 TCP.
      # No 0.0.0.0/0 rule — add per-host overrides if a trusted network
      # ever genuinely needs remote access (scram-sha-256, narrow CIDR).
    };

    environment.systemPackages = with pkgs; [
      pgformatter
      pgadmin4
    ];
  };
}
