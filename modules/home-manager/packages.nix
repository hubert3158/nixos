# User packages configuration
{ config, lib, pkgs, ... }:

let
  cfg = config.modules.packages;
in
{
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
        zed-editor
        helix
        jetbrains.datagrip
        jetbrains.idea
        vscode-extensions.vscjava.vscode-java-debug
        jprofiler
        eclipse-mat
        lazygit
        ripgrep
        sd

        # Language servers
        lua-language-server
        jdt-language-server
        nil
        bash-language-server
        zls

        # Python with packages
        (python312.withPackages (ps:
          with ps; [
            reportlab
            openai
            pandas
            boto3
            pypdf
            pypdf2
            pdfplumber
            pdf2image
            pytesseract
            requests
            flask
            flask-cors
            paramiko
          ]))
        pipx
      ])

      # Productivity packages
      ++ (lib.optionals cfg.enableProductivity [
        obsidian
        pandoc
        mdbook-pdf
        libreoffice
        teams-for-linux
        discord
        onedrive
        krusader
        chatgpt-cli
      ])

      # Multimedia packages
      ++ (lib.optionals cfg.enableMultimedia [
        obs-studio
        pavucontrol
        yazi
      ])

      # Networking/Security packages
      ++ (lib.optionals cfg.enableNetworking [
        wrk
        mtr
        dig
        dnstop
        nmap
        nikto
        zap
        wireshark-qt
        protonvpn-gui
        freerdp
        openvpn
        sshfs
      ])

      # System utilities
      ++ [
        parted
        dosfstools
        ntfs3g
        rsync
        util-linux
        btop
        grim
        slurp
        figlet
        warp-terminal
      ]

      # Browsers
      ++ [
        google-chrome
        brave
      ]

      # Fun packages
      ++ (lib.optionals cfg.enableFun [
        cmatrix
        neofetch
        frotz
      ])

      # Zsh tools
      ++ [
        zsh-autocomplete
      ];
  };
}
