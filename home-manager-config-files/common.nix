{pkgs, ...}: {
  home.stateVersion = "24.11"; # Use the latest stable version number that aligns with your Home Manager version
  home.username = "hubert";
  home.homeDirectory = "/home/hubert";
  home.shellAliases = {
    "gs" = "git status";
    "gaa" = "git add .";
    "gp" = "git push";
    "gwip" = "git commit -m \"wip\"";
    "v" = "nvim";
    "vi" = "nvim";
    "r" = "ranger";
    "cd" = "z";
    "y" = "yazi";
    "open" = "xdg-open";
    "lww" = "hyprctl dispatch exec waybar";
    "l" = "eza --icons --group-directories-first --git --header --time-style=iso --color=always";
    "ll" = "eza -l --icons --group-directories-first --git --header --time-style=iso --color=always";
    "la" = "eza -la --icons --group-directories-first --git --header --time-style=iso --color=always";
    "lt" = "eza --tree --icons --level=2 --group-directories-first --git --time-style=iso --color=always";
    "ss" = "sleep 2 && grim -g \"\$(slurp)\" - | tee ~/Pictures/screenshot-\$(date +%Y%m%d-%H%M%S).png | wl-copy";
    "f" = ''
      fzf \
      -i \
      --margin 5% --padding 5% --border --preview 'cat {}' \
      --bind 'enter:execute(nvim {})' \
      --color bg:#222222,preview-bg:#333333
    '';
    "gr" = ''
      git status --porcelain | fzf --height 40% --border | awk '{print $2}' | xargs git restore
    '';
    "h" = "omz_history | fzf > selected";
  };
  home.sessionVariables = {
    PATH = "$HOME/.local/bin:$PATH";
  };
  wayland.windowManager.hyprland = {
    # If you use the Home Manager module, make sure to disable the systemd integration, as it conflicts with uwsm.
    # https://wiki.hyprland.org/Useful-Utilities/Systemd-start/
    systemd.enable = false;
    enable = true;
    xwayland.enable = true;
    extraConfig = ''source = ~/nixos/dotfiles/hypr/hyprland.conf '';
  };

  home.packages = with pkgs; [
    # Add your user packages here
    keychain

    pgadmin

    freerdp
    openvpn
    # aws-workspaces

    eclipse-mat

    btop

    #fun
    cmatrix
    neofetch
    frotz

    jprofiler

    # android-studio
    # android-tools

    sshfs

    figlet

    google-chrome
    jetbrains.idea-ultimate
    jetbrains.datagrip
    # jetbrains.pycharm-professional
    jetbrains-toolbox
    onedrive
    vscode-extensions.vscjava.vscode-java-debug

    zig_0_12
    zls

    discord
    pgadmin4
    pavucontrol
    helix
    zsh-autocomplete
    mtr
    flameshot
    grim
    slurp
    postman
    teams-for-linux
    ripgrep
    lazygit

    dig
    # busybox //set of tools and stuff but it will overwrite the version installed
    dnstop

    nmap
    nikto
    zap

    wireshark-qt

    obsidian
    pandoc
    # texlive.combined.scheme-full
    mdbook-pdf

    protonvpn-cli_2

    pipx
    (python312.withPackages (ps:
      with ps; [
        reportlab
        openai
        pandas
        pypdf
        pypdf2
        # pymupdf # marked as broken for the latest version
        pdfplumber
        pdf2image
        pytesseract
        flask
      ]))

    lua-language-server
    jdt-language-server
    nil
    bash-language-server
    zls

    dejavu_fonts

    obs-studio

    alacritty-theme

    krusader
    swayimg
    yazi # ⚡️Blazing Fast Terminal File Manager

    chatgpt-cli

    exiftool #A tool to read, write and edit EXIF meta information
    warp-terminal #Rust-based terminal.
  ];
  nixpkgs.config = {
    allowUnfree = true;
    permittedInsecurePackages = [
      "python-2.7.18.8"
    ];
  };

  programs.eza = {
    enable = true;
    colors = "always";
    enableZshIntegration = true;
    icons = "always";
  };

  programs.zsh = {
    enable = true;
    autosuggestion = {
      enable = true;
      highlight = "fg=red,bold,underline";
    };
    enableCompletion = true;

    oh-my-zsh = {
      enable = true;
      theme = "robbyrussell";
      plugins = [
        "git"
        "npm"
        "history"
        "node"
        "rust"
        "deno"
      ];
    };

    # zellij attach --create local
    # eval "$(/nix/store/2h1mvikc160c7i8kzvp9d289pvs1z6vx-zellij-0.40.1/bin/zellij attach --create local)"
    # zellij attach --create local
    initExtra = ''
      neofetch
    '';
    profileExtra = ''
      echo ">>> Loading SSH keys via keychain..."

      # Dynamically find all valid SSH private keys
      KEYS=$(find ~/.ssh -type f \
        ! -name "*.pub" \
        ! -name "known_hosts*" \
        ! -name "*.pem" \
        -exec sh -c '
          for key; do
            ssh-keygen -lf "$key" >/dev/null 2>&1 && echo "$key"
          done
        ' _ {} +)

      echo ">>> Detected SSH keys: $KEYS"

      # Force keychain to reuse agent and re-evaluate all valid keys
      eval "$(keychain --eval --quiet --agents ssh --inherit any $KEYS)"

      # Zoxide helpers
      zi() {
        zoxide query -i "$@" | fzf --height 40% --reverse --inline-info | xargs -I {} zoxide cd {}
      }

      zia() {
        zoxide query -i "$@" | fzf --height 40% --reverse --inline-info | xargs -I {} zoxide add {}
      }
    '';
  };

  programs.wezterm = {
    enable = true;
    # color_scheme = "Catppuccin Frappé (Gogh)",
    extraConfig = ''
      return {
        font = wezterm.font("JetBrains Mono"),
        font_size = 16.0,
        color_scheme = "Catppuccin Frappe",
        hide_tab_bar_if_only_one_tab = true,
        default_prog = { "zsh", "--login", "-c", "tmux attach -t dev || tmux new -s dev" },
        keys = {
          {key="n", mods="SHIFT|CTRL", action=wezterm.action.ToggleFullScreen},
        },
        window_background_image = '/home/hubert/nixos/images/wallpaper.png',
        window_background_image_hsb = {
          brightness = 0.5,
          hue = 0.5,
          saturation = 0.7,
        },
      }
    '';
  };

  programs.ssh = {
    enable = true;
    extraConfig = ''
      Host *
      ForwardAgent yes
      ForwardX11 no
      ForwardX11Trusted yes
      ServerAliveInterval 60
      ServerAliveCountMax 30

      Host stg
      HostName staging.v2.smartmca.com
      User ubuntu
      Port 22
      IdentityFile ~/.ssh/staging.v2.pem

      Host prod
      HostName app.v2.smartmca.com
      User ubuntu
      Port 22
      IdentityFile ~/.ssh/prod.v2.pem

      Host wellMed
      HostName 100.29.157.104
      User ubuntu
      Port 22

      Host submission
      HostName 35.153.23.89
      User ubuntu
      Port 22
      IdentityFile ~/.ssh/automated_submission.pem


      Host dev
      HostName 44.220.241.10
      User ubuntu
      Port 22
      IdentityFile ~/.ssh/dev_server.pem

      Host demo
      HostName 35.153.23.89
      User ubuntu
      Port 22
      IdentityFile ~/.ssh/demo.pem

      Host bluetangles
      HostName bluetangles.com
      User ubuntu
      Port 22
      IdentityFile ~/.ssh/bluetangles.pem
    '';
  };

  programs.git = {
    enable = true;
    extraConfig = {
      user.name = "Subash Acharya";
      user.email = "hubert3158@gmail.com";
      core.editor = "vim";
      diff.tool = "vimdiff";
      difftool.prompt = false;
      alias.co = "checkout";
      alias.br = "branch";
      alias.ci = "commit";
      alias.st = "status";
      alias.lg = "log --graph --oneline --all";
      commit.gpgSign = false;
    };
  };

  programs.hyprlock = {
    enable = true;
    settings = {
      general = {
        disable_loading_bar = true;
        grace = 300;
        hide_cursor = true;
        no_fade_in = false;
      };

      background = [
        {
          path = "~/nixos/images/wallpaper.png";
          blur_passes = 3;
          blur_size = 8;
        }
      ];

      input-field = [
        {
          size = "200, 50";
          position = "0, -80";
          monitor = "";
          dots_center = true;
          fade_on_empty = false;
          font_color = "rgb(202, 211, 245)";
          inner_color = "rgb(91, 96, 120)";
          outer_color = "rgb(24, 25, 38)";
          outline_thickness = 5;
          placeholder_text = ''<span foreground="##cad3f5">Password...</span>'';
          shadow_passes = 2;
        }
      ];
    };
  };

  services.hyprpaper = {
    enable = true;
    settings = {
      ipc = "on";
      splash = false;
      splash_offset = 2.0;

      preload = ["~/nixos/images/wallpaper.png" ""];

      wallpaper = [
        "DP-1,~/nixos/images/wallpaper.png"
        "DP-2,~/nixos/images/wallpaper.png"
        "DP-3,~/nixos/images/wallpaper.png"
        "eDP-1,~/nixos/images/wallpaper.png"
        "HDMI-A-1,~/nixos/images/wallpaper.png"
      ];
    };
  };

  programs.waybar = {
    enable = true;
    package = pkgs.waybar;
  };

  programs.wofi = {
    enable = true;
    style = ''
      * {
        font-family: monospace;
      }

      window {
        background-color: #7c818c;
      }
    '';
  };

  #   [Desktop Entry]
  # Name=swayimg
  # Comment=Image viewer for sway
  # Exec=swayimg %f
  # Icon=swayimg
  # Terminal=false
  # Type=Application
  # Categories=Graphics;Viewer;

  programs.zoxide = {
    enable = true;
    package = pkgs.zoxide;
    options = [
      # "--no-aliases"
    ];
    enableZshIntegration = true;
  };

  # programs.eww = {
  #   enable = true;
  #   package = pkgs.eww;
  #   configDir = ./home-manager-config-files/eww;
  # };

  services.gnome-keyring = {
    enable = true;
    components = ["secrets"];
  };

  services.gpg-agent.enable = true;
  services.gpg-agent.enableZshIntegration = true;
  services.gpg-agent.enableSshSupport = true;

  services.gpg-agent.pinentryPackage = pkgs.pinentry-gnome3;

  programs.neomutt = {
    enable = true;
    editor = "nvim";
  };
  programs.git-credential-oauth.enable = true;

  programs.zathura.enable = true; #pdf viewer
  programs.mpv.enable = true; #pdf viewer

  imports = [
    ./tmux.nix
    #./vim.nix
    # ./neovim.nix
    ./alacritty.nix
    ./kitty.nix
    ./xdg.nix
    ./yazi.nix
    ./ranger.nix
    ./zellij.nix
  ];
}
