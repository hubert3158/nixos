# Secrets management module using sops-nix
{ config, lib, pkgs, inputs, ... }:

let
  cfg = config.modules.secrets;
in
{
  options.modules.secrets = {
    enable = lib.mkEnableOption "sops-nix secrets management";

    defaultSopsFile = lib.mkOption {
      type = lib.types.path;
      default = ../../secrets/secrets.yaml;
      description = "Default sops file for secrets";
    };

    ageKeyFile = lib.mkOption {
      type = lib.types.str;
      default = "/home/hubert/.config/sops/age/keys.txt";
      description = "Path to age private key file";
    };
  };

  config = lib.mkIf cfg.enable {
    sops = {
      defaultSopsFile = cfg.defaultSopsFile;
      age.keyFile = cfg.ageKeyFile;

      # Example secret definitions
      # Uncomment and modify as needed
      # secrets = {
      #   "api_keys/github_token" = {
      #     owner = config.users.users.hubert.name;
      #   };
      #   "database/postgres_password" = {
      #     owner = "postgres";
      #   };
      # };
    };

    # Ensure sops and age are available
    environment.systemPackages = with pkgs; [
      sops
      age
      ssh-to-age
    ];
  };
}
