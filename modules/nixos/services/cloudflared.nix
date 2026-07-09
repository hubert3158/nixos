# Cloudflare tunnel — exposes a local service over a public hostname.
# Runs as a systemd service (DynamicUser); systemd LoadCredential reads the
# credentials JSON as root at start, so the file may stay in the user's home.
#
# No defaults for tunnelId/hostname — set them in the host config that runs
# the tunnel (this repo is public; identifiers don't belong in module defaults).
#
# =============================================================================
# HOW TO SET UP / ROTATE A TUNNEL (runbook — no need to ask anyone)
# =============================================================================
# Symptom you're fixing if a tunnel is "broken": the systemd service is
# active/running but its log loops with
#   ERR ... "control stream encountered a failure while serving"
#   INF Retrying connection in up to 1m...
# That means the QUIC handshake to Cloudflare edge SUCCEEDS but the edge
# REJECTS the credentials — i.e. the tunnelId in the host config points at a
# tunnel that does NOT exist in the account (deleted, never created, or wrong
# account). Confirm with step 4 below: `cloudflared tunnel list`.
#
# Prereqs: the `cloudflared` CLI is on PATH (it is, via this module). All
# `cloudflared tunnel ...` commands authenticate with ~/.cloudflared/cert.pem
# and run NON-interactively except `login` (which opens a browser).
#
#   # 0. Log in to the zone (browser opens; pick the domain, e.g. bluetangles.com).
#   #    Writes ~/.cloudflared/cert.pem (origin cert / API token for that zone).
#   #    Only needed once per machine, or after the cert is revoked.
#   cloudflared tunnel login
#
#   # 1. DELETE the old/dead tunnel if one exists (server-side). Skip if none.
#   #    `delete` also removes its DNS routes. Find names/UUIDs via step 4.
#   cloudflared tunnel delete <OLD_NAME_OR_UUID>
#
#   # 2. REMOVE the stale local credentials JSON for that dead tunnel.
#   rm -f ~/.cloudflared/<OLD_UUID>.json
#
#   # 3. CREATE a fresh tunnel. Prints the new UUID and writes the credentials
#   #    to ~/.cloudflared/<NEW_UUID>.json — exactly where credentialsFile
#   #    (below) defaults to, so no path override is needed.
#   cloudflared tunnel create <NAME>          # e.g. bluetangles-dev
#
#   # 4. ROUTE a hostname to the tunnel (creates a proxied CNAME in Cloudflare
#   #    DNS). Use a free subdomain (e.g. dev.bluetangles.com) so the apex
#   #    record is left untouched. Add --overwrite-dns ONLY if the name already
#   #    has a record you intend to replace.
#   cloudflared tunnel route dns <NAME> <HOSTNAME>   # e.g. ... dev.bluetangles.com
#
#   # 5. VERIFY the tunnel exists and the route resolves.
#   cloudflared tunnel list                          # new UUID + NAME should appear
#   dig +short <HOSTNAME> @1.1.1.1                    # should hit Cloudflare proxy IPs
#
#   # 6. WIRE it into the host config that runs the tunnel:
#   #    hosts/<host>/default.nix
#   #      modules.services.cloudflared = {
#   #        enable   = true;
#   #        tunnelId = "<NEW_UUID>";       # from step 3 / step 5
#   #        hostname = "<HOSTNAME>";       # from step 4 (must match the route)
#   #        service  = "http://127.0.0.1:5173";   # optional; default below
#   #      };
#
#   # 7. REBUILD to regenerate the systemd unit + config for the new tunnel.
#   sudo nixos-rebuild switch --flake ~/nixos#<host>      # e.g. ...#work
#
#   # 8. CONFIRM it's healthy (no more retry loop).
#   systemctl status 'cloudflared-tunnel-*'              # want: Registered tunnel connection
#   journalctl -u 'cloudflared-tunnel-*' -n 20 --no-pager
#   curl -I https://<HOSTNAME>                           # reaches the local service
#
# Don't forget: the local service from step 6's `service =` must actually be
# listening (e.g. vite on :5173) or you'll get a 502 from the edge even though
# the tunnel itself is healthy.
# =============================================================================
{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.modules.services.cloudflared;
in {
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
