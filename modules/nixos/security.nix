# Security configuration
#
# NOTE: gpg-agent is deliberately NOT configured here. It is owned solely by
# home-manager (`modules/home-manager/programs/gpg.nix` -> services.gpg-agent).
# Enabling `programs.gnupg.agent` as well installs a second set of
# gpg-agent.{service,socket} units (/etc/systemd/user vs ~/.config/systemd/user)
# and a second SSH_AUTH_SOCK export; the two stacks end up with different
# socket dirs and two keyboxd daemons fighting over the
# ~/.gnupg/public-keys.d/pubring.db dotlock, which makes every gpg read fail
# with "keydb_search failed: Connection timed out".
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

    enableSmartcard = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Enable pcscd for smart card support (OpenPGP cards, YubiKey)";
    };
  };

  config = lib.mkIf cfg.enable {
    security.rtkit.enable = cfg.enableRtkit;
    security.polkit.enable = cfg.enablePolkit;

    # GNOME Keyring integration with display manager
    security.pam.services.sddm.enableGnomeKeyring = cfg.enableGnomeKeyring;

    services.gnome.gnome-keyring.enable = cfg.enableGnomeKeyring;

    # PCSCD for smart card support
    services.pcscd.enable = cfg.enableSmartcard;

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
