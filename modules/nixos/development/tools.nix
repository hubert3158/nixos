# Development tools configuration
{ config, lib, pkgs, ... }:

let
  cfg = config.modules.development.tools;
  prisma-schema-engine-static = pkgs.callPackage ../../../packages/prisma-schema-engine-static { };
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
    # Uses static binary as workaround for prisma-engines Rust compilation issue (rust-lang/rust#141402)
    # Prisma 7.x only needs schema-engine for migrations; query engine is built into the client
    environment.variables = lib.mkIf cfg.enablePrisma {
      PRISMA_SCHEMA_ENGINE_BINARY = "${prisma-schema-engine-static}/bin/schema-engine";
    };

    environment.systemPackages = with pkgs;
      # Core development tools
      [
        git
        gh
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

      # Playwright (E2E testing)
      ++ [
        playwright-driver
      ]

      # Prisma (static schema-engine only; Prisma 7.x query engine is built into @prisma/client)
      ++ (lib.optionals cfg.enablePrisma [
        prisma-schema-engine-static
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
