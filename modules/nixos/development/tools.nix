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
      # google-chrome is referenced by the systemd.tmpfiles rule below that satisfies
      # playwright-cli's hardcoded /opt/google/chrome/chrome lookup on Linux.
      ++ [
        playwright-driver
        google-chrome
      ]

      # Prisma
      ++ (lib.optionals cfg.enablePrisma [
        prisma
        prisma-engines
      ]);

    # playwright-cli hardcodes /opt/google/chrome/chrome for the "chrome" channel on Linux
    # (--browser only accepts chrome|firefox|webkit|msedge, no chromium, no env override).
    # Symlink it to the Nix-managed google-chrome so the lookup resolves.
    systemd.tmpfiles.rules = [
      "d /opt               0755 root root - -"
      "d /opt/google        0755 root root - -"
      "d /opt/google/chrome 0755 root root - -"
      "L+ /opt/google/chrome/chrome - - - - ${pkgs.google-chrome}/bin/google-chrome-stable"
    ];

    # Session variables for editors/tools
    environment.sessionVariables = {
      EDITOR = "nvim";
      PAGER = "less";
      BROWSER = "firefox";
      FILE_MANAGER = "ranger";
      PDF_VIEWER = "zathura";
      TERMINAL = "alacritty";
    };

    # Prisma environment variables
    environment.variables = lib.mkIf cfg.enablePrisma {
      PRISMA_SCHEMA_ENGINE_BINARY = "${pkgs.prisma-engines}/bin/schema-engine";
      PRISMA_QUERY_ENGINE_BINARY = "${pkgs.prisma-engines}/bin/query-engine";
      PRISMA_QUERY_ENGINE_LIBRARY = "${pkgs.prisma-engines}/lib/libquery_engine.node";
    };
  };
}
