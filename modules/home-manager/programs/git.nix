# Git configuration
{ config, lib, pkgs, ... }:

let
  cfg = config.modules.programs.git;
in
{
  options.modules.programs.git = {
    enable = lib.mkEnableOption "Git configuration";

    userName = lib.mkOption {
      type = lib.types.str;
      default = "Subash Acharya";
      description = "Git user name";
    };

    userEmail = lib.mkOption {
      type = lib.types.str;
      default = "hubert3158@gmail.com";
      description = "Git user email";
    };

    enableGpgSigning = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable GPG signing for commits";
    };

    enableDelta = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Enable delta for git diffs";
    };

    enableCredentialOauth = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Enable git-credential-oauth";
    };
  };

  config = lib.mkIf cfg.enable {
    programs.git = {
      enable = true;
      settings = {
        user.name = cfg.userName;
        user.email = cfg.userEmail;
        core.editor = "vim";
        diff.tool = "vimdiff";
        difftool.prompt = false;
        alias.co = "checkout";
        alias.br = "branch";
        alias.ci = "commit";
        alias.st = "status";
        alias.lg = "log --graph --oneline --all";
        commit.gpgSign = cfg.enableGpgSigning;
      };
    };

    programs.delta = lib.mkIf cfg.enableDelta {
      enable = true;
      enableGitIntegration = true;
      options = {
        features = "decorations";
        syntax-theme = "Monokai Extended";
        line-numbers = true;
        side-by-side = true;
      };
    };

    programs.git-credential-oauth.enable = cfg.enableCredentialOauth;
  };
}
