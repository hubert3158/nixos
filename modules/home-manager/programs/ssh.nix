# SSH client configuration
#
# Work/private host definitions are NOT tracked in this repo (it is public).
# They live in ~/.ssh/config.d/ (e.g. ~/.ssh/config.d/work), pulled in via the
# Include below. A glob include that matches nothing is a silent no-op, so
# fresh machines work before the file exists. See POST_INSTALL.md.
{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.modules.programs.ssh;
in {
  options.modules.programs.ssh = {
    enable = lib.mkEnableOption "SSH client configuration";

    enableForwardAgent = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Enable SSH agent forwarding";
    };

    serverAliveInterval = lib.mkOption {
      type = lib.types.int;
      default = 60;
      description = "Server alive interval in seconds";
    };

    serverAliveCountMax = lib.mkOption {
      type = lib.types.int;
      default = 30;
      description = "Maximum server alive count";
    };
  };

  config = lib.mkIf cfg.enable {
    programs.ssh = {
      enable = true;
      enableDefaultConfig = false;

      # Untracked host definitions (work servers etc.)
      includes = [ "config.d/*" ];

      settings = {
        "*" = {
          ForwardAgent = cfg.enableForwardAgent;
          ForwardX11 = false;
          ForwardX11Trusted = true;
          ServerAliveInterval = cfg.serverAliveInterval;
          ServerAliveCountMax = cfg.serverAliveCountMax;
          KexAlgorithms = "sntrup761x25519-sha512@openssh.com,curve25519-sha256,curve25519-sha256@libssh.org";
        };

        "github.com-work" = {
          HostName = "github.com";
          User = "git";
          IdentityFile = "~/.ssh/id_ed25519_work";
          IdentitiesOnly = true;
        };

        "github.com" = {
          HostName = "github.com";
          User = "git";
          IdentityFile = "~/.ssh/id_ed25519";
          IdentitiesOnly = true;
        };
      };
    };
  };
}
