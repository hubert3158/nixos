# Programming languages configuration
{ config, lib, pkgs, ... }:

let
  cfg = config.modules.development.languages;
in
{
  options.modules.development.languages = {
    enable = lib.mkEnableOption "programming languages";

    enableNode = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Enable Node.js and related tools";
    };

    enablePython = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Enable Python and related tools";
    };

    enableGo = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Enable Go programming language";
    };

    enableRust = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Enable Rust programming language";
    };

    enableJava = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Enable Java development";
    };

    enableC = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Enable C/C++ development";
    };

    enableZig = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable Zig programming language";
    };

    enableR = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Enable R programming language";
    };
  };

  config = lib.mkIf cfg.enable {
    # Enable Java system-wide
    programs.java.enable = cfg.enableJava;

    # Java environment variables
    environment.variables = lib.mkIf cfg.enableJava {
      JAVA_HOME = "${pkgs.jdk25}/lib/openjdk";
      JAVA_HOME11 = "${pkgs.jdk11}/lib/openjdk";
      JAVA_HOME21 = "${pkgs.jdk21}/lib/openjdk";
      JAVA_HOME25 = "${pkgs.jdk25}/lib/openjdk";
    };

    environment.shellInit = lib.mkIf cfg.enableJava ''
      export PATH=$JAVA_HOME/bin:$PATH
    '';

    environment.systemPackages = with pkgs;
      # Node.js packages
      (lib.optionals cfg.enableNode [
        nodejs
        nodejs_22
        nodemon
        eslint
        serve
        prettier
        pm2
        htmlhint
        typescript
        pnpm
        yarn
        prettierd
        eslint_d
        # LSP servers for Doom (javascript +lsp) / (web +lsp) / (yaml +lsp).
        # ts-ls backs js/ts/jsx/tsx; Volar (vue-language-server) attaches its
        # TS host to ts-ls; vscode-langservers-extracted (in tools.nix) provides
        # html/css/json/eslint servers.
        typescript-language-server
        vue-language-server
        yaml-language-server
      ])

      # Python packages
      ++ (lib.optionals cfg.enablePython [
        python3
        python3Packages.isort
        python3Packages.black
        python3Packages.flake8
        pyright
        uv
      ])

      # Go packages
      ++ (lib.optionals cfg.enableGo [
        go
        gotools       # goimports
        gopls         # Go LSP
        delve         # dlv — DAP debugger (dape built-in `dlv` config)
        golangci-lint # linter (flycheck-golangci-lint)
      ])

      # Rust packages
      ++ (lib.optionals cfg.enableRust [
        rustup
        # Declarative rust-analyzer so Rust LSP works without an imperative
        # `rustup component add rust-analyzer`. hiPrio wins the bin/rust-analyzer
        # collision against rustup's proxy shim (which needs ~/.rustup state).
        (lib.hiPrio rust-analyzer)
        # Same shim-collision story for rustfmt (apheleia format-on-save) and
        # clippy (rust-analyzer checkOnSave). hiPrio makes the real binaries win
        # over rustup's proxies. If a rustup stable toolchain version-mismatches
        # nixpkgs clippy-driver, drop clippy here and `rustup component add clippy`.
        (lib.hiPrio rustfmt)
        (lib.hiPrio clippy)
      ])

      # Java packages
      ++ (lib.optionals cfg.enableJava [
        jdk11
        jdk21
        jdk25
        maven
        gradle
        google-java-format
      ])

      # C/C++ packages
      ++ (lib.optionals cfg.enableC [
        gcc
        gnumake
        clang
        clang-tools
        ccls
        libclang
        glibc.dev
        gdb           # dape built-in `gdb` c/c++ DAP config
        lldb          # provides lldb-dap for dape's `lldb-dap` config
        # Windows cross-compiler (x86_64-w64-mingw32-gcc), fully cached upstream
        pkgsCross.mingwW64.buildPackages.gcc
      ])

      # Zig packages
      ++ (lib.optionals cfg.enableZig [
        zig
        zls
      ])

      # R packages
      ++ (lib.optionals cfg.enableR [
        (rWrapper.override {
          packages = with rPackages; [
            languageserver
            tidyverse
            ggplot2
            dplyr
            readr
            jsonlite
          ];
        })
      ]);
  };
}
