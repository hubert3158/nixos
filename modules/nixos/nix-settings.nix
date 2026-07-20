# Nix daemon and flake settings
{ config, lib, pkgs, ... }:

let
  cfg = config.modules.nix;
in
{
  options.modules.nix = {
    enable = lib.mkEnableOption "Nix settings configuration";

    enableFlakes = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Enable flakes and nix-command";
    };

    stateVersion = lib.mkOption {
      type = lib.types.str;
      default = "24.11";
      description = "NixOS state version";
    };

    gc = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Enable automatic garbage collection";
      };

      dates = lib.mkOption {
        type = lib.types.str;
        default = "weekly";
        description = "When to run garbage collection";
      };

      options = lib.mkOption {
        type = lib.types.str;
        default = "--delete-older-than 30d";
        description = "Options for garbage collection";
      };
    };
  };

  config = lib.mkIf cfg.enable {
    system.stateVersion = cfg.stateVersion;

    nix.settings.experimental-features = lib.mkIf cfg.enableFlakes [
      "nix-command"
      "flakes"
    ];

    nix.gc = lib.mkIf cfg.gc.enable {
      automatic = true;
      dates = cfg.gc.dates;
      options = cfg.gc.options;
    };

    # Scheduled store deduplication (preferred over per-write
    # auto-optimise-store, which slows every build)
    nix.optimise.automatic = true;

    # Builds must never stutter the desktop — run the daemon at idle
    # CPU/IO priority; it still uses every core when the machine is free
    nix.daemonCPUSchedPolicy = "idle";
    nix.daemonIOSchedClass = "idle";

    # Extra binary cache for nix-community packages
    nix.settings.substituters = [ "https://nix-community.cachix.org" ];
    nix.settings.trusted-public-keys = [
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
    ];

    # Useful Nix-related packages
    environment.systemPackages = with pkgs; [
      nix-index
      home-manager
    ];
  };
}
