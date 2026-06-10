# Cloudflare tunnel — exposes a local service over a public hostname.
# Runs as a systemd service (DynamicUser); systemd LoadCredential reads the
# credentials JSON as root at start, so the file may stay in the user's home.
#
# No defaults for tunnelId/hostname — set them in the host config that runs
# the tunnel (this repo is public; identifiers don't belong in module defaults).
{ config, lib, pkgs, ... }:

let
  cfg = config.modules.services.cloudflared;
in
{
  options.modules.services.cloudflared = {
    enable = lib.mkEnableOption "Cloudflare tunnel";

    tunnelId = lib.mkOption {
      type = lib.types.str;
      description = "Cloudflare tunnel UUID (from `cloudflared tunnel create`)";
    };

    credentialsFile = lib.mkOption {
      type = lib.types.str;
      default = "${config.users.users.${config.modules.users.username}.home}/.cloudflared/${cfg.tunnelId}.json";
      description = "Path to the tunnel credentials JSON. Read by root via LoadCredential.";
    };

    hostname = lib.mkOption {
      type = lib.types.str;
      description = "Public hostname routed to the tunnel (must have a DNS CNAME)";
    };

    service = lib.mkOption {
      type = lib.types.str;
      default = "http://127.0.0.1:5173";
      description = "Local service the tunnel forwards traffic to";
    };
  };

  config = lib.mkIf cfg.enable {
    services.cloudflared = {
      enable = true;
      tunnels.${cfg.tunnelId} = {
        credentialsFile = cfg.credentialsFile;
        ingress.${cfg.hostname} = cfg.service;
        default = "http_status:404";
      };
    };
  };
}
