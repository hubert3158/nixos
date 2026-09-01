# GPG agent configuration
#
# This module is the ONLY owner of gpg-agent. `programs.gnupg.agent` on the
# NixOS side is intentionally left off (see modules/nixos/security.nix) —
# running both installs two competing sets of gpg-agent units and two keyboxd
# daemons, which deadlock on the ~/.gnupg/public-keys.d/pubring.db dotlock.
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

    cacheTtl = lib.mkOption {
      type = lib.types.int;
      default = 600;
      description = "GPG agent passphrase cache TTL in seconds";
    };
  };

  config = lib.mkIf cfg.enable {
    services.gpg-agent = {
      enable = true;
      enableZshIntegration = cfg.enableZshIntegration;
      enableSshSupport = cfg.enableSshSupport;
      defaultCacheTtl = cfg.cacheTtl;
      defaultCacheTtlSsh = cfg.cacheTtl;
      pinentry.package = pkgs.pinentry-gnome3;
    };

    services.gnome-keyring = {
      enable = true;
      components = [ "secrets" ];
    };
  };
}
