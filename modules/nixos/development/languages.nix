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
        nodePackages.nodemon
        nodePackages.eslint
        nodePackages.serve
        nodePackages.prettier
        nodePackages.pm2
        nodePackages.htmlhint
        nodePackages.typescript
        pnpm
        yarn
        prettierd
        eslint_d
      ])

      # Python packages
      ++ (lib.optionals cfg.enablePython [
        python3
        python3Packages.isort
        python3Packages.black
        python3Packages.flake8
        pyright
      ])

      # Go packages
      ++ (lib.optionals cfg.enableGo [
        go
        gotools
      ])

      # Rust packages
      ++ (lib.optionals cfg.enableRust [
        rustup
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
      ])

      # Zig packages
      ++ (lib.optionals cfg.enableZig [
        zig
        zls
      ]);
  };
}
