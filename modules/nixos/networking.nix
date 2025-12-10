# Networking configuration
{ config, lib, pkgs, ... }:

let
  cfg = config.modules.networking;
in
{
  options.modules.networking = {
    enable = lib.mkEnableOption "networking configuration";

    hostName = lib.mkOption {
      type = lib.types.str;
      default = "nixos";
      description = "System hostname";
    };

    enableNetworkManager = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Enable NetworkManager";
    };

    nameservers = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [
        "1.1.1.1"   # Cloudflare
        "1.0.0.1"   # Cloudflare secondary
        "8.8.8.8"   # Google
        "8.8.4.4"   # Google secondary
      ];
      description = "DNS nameservers";
    };

    allowedTCPPorts = lib.mkOption {
      type = lib.types.listOf lib.types.port;
      default = [ 3000 8080 8081 993 5678 5432 5000 8083 8085 9990 4318 4317 ];
      description = "Allowed TCP ports in firewall";
    };

    allowedUDPPorts = lib.mkOption {
      type = lib.types.listOf lib.types.port;
      default = [];
      description = "Allowed UDP ports in firewall";
    };
  };

  config = lib.mkIf cfg.enable {
    networking = {
      hostName = cfg.hostName;
      networkmanager.enable = cfg.enableNetworkManager;
      nameservers = cfg.nameservers;

      firewall = {
        allowedTCPPorts = cfg.allowedTCPPorts;
        allowedUDPPorts = cfg.allowedUDPPorts;
      };
    };

    # Increase download buffer size for Nix
    nix.settings.download-buffer-size = 104857600; # 100MB
  };
}
