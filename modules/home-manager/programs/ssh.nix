# SSH client configuration
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

    # Work-specific hosts can be enabled separately
    enableWorkHosts = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Enable work SSH host configurations";
    };
  };

  config = lib.mkIf cfg.enable {
    programs.ssh = {
      enable = true;
      enableDefaultConfig = false;
      matchBlocks =
        {
          "*" = {
            forwardAgent = cfg.enableForwardAgent;
            forwardX11 = false;
            forwardX11Trusted = true;
            serverAliveInterval = cfg.serverAliveInterval;
            serverAliveCountMax = cfg.serverAliveCountMax;
            extraOptions = {
              KexAlgorithms = "sntrup761x25519-sha512@openssh.com,curve25519-sha256,curve25519-sha256@libssh.org";
            };
          };
        }
        // (lib.optionalAttrs cfg.enableWorkHosts {
          "stg" = {
            hostname = "0.0.0.0";
            user = "ubuntu";
            port = 22;
            identityFile = "~/.ssh/staging.v2.pem";
          };

          "prod" = {
            hostname = "REDACTED-HOST-PROD";
            user = "ubuntu";
            port = 22;
            identityFile = "~/.ssh/prod.v2.pem";
          };

          "wellMed" = {
            hostname = "0.0.0.0";
            user = "ubuntu";
            port = 22;
          };

          "submission" = {
            hostname = "0.0.0.0";
            user = "ubuntu";
            port = 22;
            identityFile = "~/.ssh/automated_submission.pem";
          };

          "dev" = {
            hostname = "0.0.0.0";
            user = "ubuntu";
            port = 22;
            identityFile = "~/.ssh/dev_server.pem";
          };

          "demo" = {
            hostname = "0.0.0.0";
            user = "ubuntu";
            port = 22;
            identityFile = "~/.ssh/demo.pem";
          };

          "REDACTED-BT" = {
            hostname = "REDACTED-HOST-BT";
            user = "ubuntu";
            port = 22;
            identityFile = "~/.ssh/REDACTED-BT.pem";
          };

          "rules-engine" = {
            hostname = "0.0.0.0";
            user = "ubuntu";
            port = 22;
            identityFile = "~/.ssh/rules_engine.pem";
          };
        });
    };
  };
}
