# Git configuration
{ config, lib, pkgs, palette, ... }:

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
      signing.format = "openpgp";
      settings = {
        user.name = cfg.userName;
        user.email = cfg.userEmail;
        core.editor = "nvim";
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
        # points at the [delta "kanagawa"] feature below — the old
        # `features = "decorations"` referenced a section that never
        # existed, so every style here was a silent no-op
        features = "kanagawa";
        kanagawa = {
          # "ansi" follows the terminal palette → kanagawa (docs/THEME.md)
          syntax-theme = "ansi";
          line-numbers = true;
          side-by-side = true;
          # winter washes: syntax highlighting on tinted ink backgrounds
          minus-style = "syntax ${palette.winterRed}";
          minus-emph-style = "syntax ${palette.ansiRed}";
          plus-style = "syntax ${palette.winterGreen}";
          plus-emph-style = "syntax ${palette.ansiGreen}";
          line-numbers-minus-style = palette.ansiRed;
          line-numbers-plus-style = palette.ansiGreen;
          line-numbers-zero-style = palette.sumiInk6;
          file-style = "bold ${palette.carpYellow}";
          file-decoration-style = "ul ${palette.sumiInk6}";
          hunk-header-style = "syntax italic ${palette.springViolet1}";
          hunk-header-decoration-style = "ul ${palette.sumiInk6}";
        };
      };
    };

    programs.git-credential-oauth.enable = cfg.enableCredentialOauth;
  };
}
