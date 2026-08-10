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

        # Postgres defaults to 64, which is a per-transaction ceiling on lock
        # slots. Dropping a whole schema takes one lock per table, index,
        # policy and trigger in a single transaction, so `prisma migrate reset`
        # on a large dev database (~500 tables, RLS policies on most of them)
        # dies partway with:
        #
        #   ERROR: out of shared memory
        #   HINT:  You might need to increase max_locks_per_transaction.
        #
        # It fails *after* dropping _prisma_migrations, which leaves the
        # database orphaned — schema present, migration history gone — so the
        # only way out is DROP DATABASE and a full replay. 2026-08-10.
        #
        # Costs shared memory at startup: roughly this × max_connections lock
        # slots are preallocated. A few MB at these numbers, and it is a
        # restart-only parameter (not reloadable).
        max_locks_per_transaction = 1024;
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
