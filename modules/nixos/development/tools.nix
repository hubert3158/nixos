# Development tools configuration
{ config, lib, pkgs, ... }:

let
  cfg = config.modules.development.tools;
in
{
  options.modules.development.tools = {
    enable = lib.mkEnableOption "development tools";

    enableLSP = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Enable Language Server Protocol servers";
    };

    enableFormatters = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Enable code formatters";
    };

    enableDebuggers = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Enable debuggers";
    };

    enableNeovim = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Enable Neovim editor";
    };

    enableTerraform = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Enable Terraform";
    };

    enableWireshark = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Enable Wireshark network analyzer";
    };

    enablePrisma = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Enable Prisma ORM support";
    };
  };

  config = lib.mkIf cfg.enable {
    # Enable Neovim system-wide
    programs.neovim.enable = cfg.enableNeovim;

    # Enable Wireshark
    programs.wireshark = lib.mkIf cfg.enableWireshark {
      enable = true;
      package = pkgs.wireshark;
    };

    # Prisma environment variables
    environment.variables = lib.mkIf cfg.enablePrisma {
      PRISMA_SCHEMA_ENGINE_BINARY = "${pkgs.prisma-engines}/bin/schema-engine";
      PRISMA_QUERY_ENGINE_BINARY = "${pkgs.prisma-engines}/bin/query-engine";
      PRISMA_QUERY_ENGINE_LIBRARY = "${pkgs.prisma-engines}/lib/libquery_engine.node";
    };

    environment.systemPackages = with pkgs;
      # Core development tools
      [
        git
        vim
        curl
        wget
        jq
        fd
        tree
        sqlite
        fzf
        skim
        ripgrep
        direnv
        devbox
        entr
        parallel
      ]

      # LSP servers
      ++ (lib.optionals cfg.enableLSP [
        nil  # Nix LSP
        vscode-langservers-extracted
        nginx-language-server
        sqls
        semgrep
        marksman
      ])

      # Formatters
      ++ (lib.optionals cfg.enableFormatters [
        stylua
        alejandra
        kulala-fmt
        pgformatter
        shfmt
        taplo
        dfmt
        sqlfluff
      ])

      # Debuggers
      ++ (lib.optionals cfg.enableDebuggers [
        vscode-js-debug
        vscode-extensions.firefox-devtools.vscode-firefox-debug
      ])

      # Terraform
      ++ (lib.optionals cfg.enableTerraform [
        terraform
      ])

      # Linters
      ++ [
        hadolint
        libxml2
      ]

      # Misc tools
      ++ [
        gnupg
        openssl
        zip
        unzip
        gzip
        util-linux
        lsof
        xclip
        sonar-scanner-cli
        ngrok
        sshpass
        audit
      ]

      # Prisma
      ++ (lib.optionals cfg.enablePrisma [
        prisma-engines
      ]);

    # Session variables for editors/tools
    environment.sessionVariables = {
      EDITOR = "nvim";
      PAGER = "less";
      BROWSER = "firefox";
      FILE_MANAGER = "ranger";
      PDF_VIEWER = "zathura";
      MUSIC_PLAYER = "mpv";
      TERMINAL = "alacritty";
    };
  };
}
