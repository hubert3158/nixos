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
      settings =
        {
          "*" = {
            ForwardAgent = cfg.enableForwardAgent;
            ForwardX11 = false;
            ForwardX11Trusted = true;
            ServerAliveInterval = cfg.serverAliveInterval;
            ServerAliveCountMax = cfg.serverAliveCountMax;
            KexAlgorithms = "sntrup761x25519-sha512@openssh.com,curve25519-sha256,curve25519-sha256@libssh.org";
          };
        }
        // (lib.optionalAttrs cfg.enableWorkHosts {
          "stg" = {
            HostName = "34.192.202.240";
            User = "ubuntu";
            Port = 22;
            IdentityFile = "~/.ssh/staging.v2.pem";
          };

          "prod" = {
            HostName = "app.v2.smartmca.com";
            User = "ubuntu";
            Port = 22;
            IdentityFile = "~/.ssh/prod.v2.pem";
          };

          "wellMed" = {
            HostName = "100.29.157.104";
            User = "ubuntu";
            Port = 22;
          };

          "submission" = {
            HostName = "35.153.23.89";
            User = "ubuntu";
            Port = 22;
            IdentityFile = "~/.ssh/automated_submission.pem";
          };

          "dev" = {
            HostName = "44.220.241.10";
            User = "ubuntu";
            Port = 22;
            IdentityFile = "~/.ssh/dev_server.pem";
          };

          "demo" = {
            HostName = "35.153.23.89";
            User = "ubuntu";
            Port = 22;
            IdentityFile = "~/.ssh/demo.pem";
          };

          "bluetangles" = {
            HostName = "bluetangles.com";
            User = "ubuntu";
            Port = 22;
            IdentityFile = "~/.ssh/bluetangles.pem";
          };

          "rules-engine" = {
            HostName = "54.166.84.96";
            User = "ubuntu";
            Port = 22;
            IdentityFile = "~/.ssh/rules_engine.pem";
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
        });
    };
  };
}
