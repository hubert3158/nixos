# User packages configuration
{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.modules.packages;
in {
  options.modules.packages = {
    enable = lib.mkEnableOption "user packages";

    enableDevelopment = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Enable development packages";
    };

    enableProductivity = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Enable productivity packages";
    };

    enableMultimedia = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Enable multimedia packages";
    };

    enableNetworking = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Enable networking/security packages";
    };

    enableFun = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Enable fun packages (neofetch, cmatrix, etc.)";
    };

    enableJetbrains = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Heavy Java IDE/profiling suite (DataGrip, IntelliJ, JProfiler, Eclipse MAT/JEE) — enable per host";
    };

    enablePentest = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Network/security testing tools (nmap, nikto, zap) — enable when needed";
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs;
    # Core packages (always included)
      [
        keychain
        waybar
        dejavu_fonts
        alacritty-theme
        swayimg
        exiftool
      ]
      # Development packages
      ++ (lib.optionals cfg.enableDevelopment [
        # EnableLater
        # zed-editor
        helix
        lazygit
        ripgrep
        rtk
        sd

        # Language servers
        lua-language-server
        jdt-language-server
        vscode-extensions.vscjava.vscode-java-debug
        vscode-extensions.vscjava.vscode-java-test
        nil
        bash-language-server
        zls
        vtsls

        # Python with packages
        (python312.withPackages (ps:
          with ps; [
            reportlab
            openai
            pandas
            boto3
            pypdf
            pdf2image
            pytesseract
            requests
            flask
            flask-cors
            paramiko
            geoip2
          ]))
        pipx
        uv
      ])
      # Heavy Java IDE / profiling suite (per-host opt-in)
      ++ (lib.optionals cfg.enableJetbrains [
        jetbrains.datagrip
        jetbrains.idea
        jprofiler
        eclipse-mat
        eclipses.eclipse-jee
      ])
      # Productivity packages
      ++ (lib.optionals cfg.enableProductivity [
        obsidian
        pandoc
        mdbook-pdf
        libreoffice

        discord
        onedrive
      ])
      # Multimedia packages
      ++ (lib.optionals cfg.enableMultimedia [
        obs-studio
        pavucontrol
        # yazi comes from modules.fileManagers.yazi
      ])
      # Networking packages
      ++ (lib.optionals cfg.enableNetworking [
        cloudflared
        wrk
        mtr
        dig
        dnstop
        proton-vpn
        freerdp
        openvpn
        sshfs
        # wireshark comes from the system module (proper dumpcap capabilities)
      ])
      # Security testing tools (opt-in)
      ++ (lib.optionals cfg.enablePentest [
        nmap
        nikto
        zap
      ])
      # System utilities
      ++ [
        parted
        dosfstools
        ntfs3g
        rsync
        util-linux
        # btop comes from modules.tools.htop
        grim
        slurp
        figlet
      ]
      # Browsers
      ++ [
        google-chrome
        brave
        # Force XWayland — native Wayland path has hover-triggered tooltip
        # rendering glitches in Edge specifically (Chrome/Brave unaffected).
        # microsoft-edge
      ]
      # Fun packages
      ++ (lib.optionals cfg.enableFun [
        cmatrix
        fastfetch
        frotz
      ])
      # Zsh tools
      ++ [
        zsh-autocomplete
      ];
  };
}
