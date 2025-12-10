# Security configuration
{ config, lib, pkgs, ... }:

let
  cfg = config.modules.security;
in
{
  options.modules.security = {
    enable = lib.mkEnableOption "security configuration";

    enableRtkit = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Enable RealtimeKit for real-time scheduling";
    };

    enablePolkit = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Enable Polkit for privilege escalation";
    };

    enableGnomeKeyring = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Enable GNOME Keyring integration";
    };

    enableGpgAgent = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Enable GPG agent with SSH support";
    };

    gpgCacheTtl = lib.mkOption {
      type = lib.types.int;
      default = 600;
      description = "GPG agent cache TTL in seconds";
    };
  };

  config = lib.mkIf cfg.enable {
    security.rtkit.enable = cfg.enableRtkit;
    security.polkit.enable = cfg.enablePolkit;

    # GNOME Keyring integration with display manager
    security.pam.services.sddm.enableGnomeKeyring = cfg.enableGnomeKeyring;

    services.gnome.gnome-keyring.enable = cfg.enableGnomeKeyring;

    # GPG Agent
    programs.gnupg.agent = lib.mkIf cfg.enableGpgAgent {
      enable = true;
      enableSSHSupport = true;
      settings = {
        default-cache-ttl = cfg.gpgCacheTtl;
      };
    };

    # PCSCD for smart card support
    services.pcscd.enable = cfg.enableGpgAgent;

    # DBus packages for GCR (GNOME crypto)
    services.dbus.packages = lib.mkIf cfg.enableGnomeKeyring [ pkgs.gcr ];

    # Required packages
    environment.systemPackages = with pkgs; [
      gnupg
      pinentry-all
      polkit
      gnome-keyring
    ];
  };
}
