
{config, pkgs, ... }:
{
  home.stateVersion = "24.05";  # Use the latest stable version number that aligns with your Home Manager version
  home.username="hubert";
  home.homeDirectory="/home/hubert";
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



  wayland.windowManager.hyprland = {
    enable = true;
    xwayland.enable = true;
    extraConfig = ''
    source = ~/nixos/dotfiles/hypr/hyprland.conf
    '';
  };

  home.packages = with pkgs; [
    # Add your user packages here

    sshfs

    google-chrome
    jetbrains.idea-ultimate
    jetbrains.datagrip
    jetbrains.pycharm-professional
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
    texlive.combined.scheme-full
    mdbook-pdf


    protonvpn-cli_2

    # (python312.withPackages (ps: with ps; [ reportlab openai])) 
    openai



    lua-language-server
    jdt-language-server
    nil
    bash-language-server
    zls


    nerdfonts
    dejavu_fonts

    obs-studio

    alacritty-theme

    krusader
    swayimg
    yazi  # ⚡️Blazing Fast Terminal File Manager 

    # rofi

    chatgpt-cli

    exiftool  #A tool to read, write and edit EXIF meta information
    warp-terminal #Rust-based terminal.

    typescript
    nodePackages.typescript-language-server

  ];
  nixpkgs.config = {
    allowUnfree = true;
    permittedInsecurePackages = [
      "python-2.7.18.8"
    ];
  };

  imports = [
    ./home-manager-config-files/tmux.nix
    ./home-manager-config-files/vim.nix
    ./home-manager-config-files/neovim.nix
    ./home-manager-config-files/alacritty.nix
    ./home-manager-config-files/kitty.nix
    ./home-manager-config-files/xdg.nix
    ./home-manager-config-files/yazi.nix
    ./home-manager-config-files/ranger.nix
    # ./home-manager-config-files/node_packages.nix
  ];

  programs.zsh = {
    enable = true;
    autosuggestion = {
      enable = true;
      highlight="fg=red,bold,underline";
    };
    enableCompletion =true;

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
    profileExtra= ''
      # Define the 'zi' function for interactive selection using fzf
      zi() {
        zoxide query -i "$@" | fzf --height 40% --reverse --inline-info | xargs -I {} zoxide cd {}
      }
      zia() {
        zoxide query -i "$@" | fzf --height 40% --reverse --inline-info | xargs -I {} zoxide add {}
      }

      '';
    };


#   programs.python = {
#   enable = true;
#   package = pkgs.python312;
#   packages = ps: with ps; [
#     reportlab
#     openai
#   ];
# };



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



programs.ssh= {
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
  IdentityFile ~/.ssh/subash

  Host prod
  HostName app.v2.smartmca.com
  User ubuntu
  Port 22
  IdentityFile ~/.ssh/prod.v2.pem
  '';
};

programs.git = {
  enable = true;
  extraConfig = {
    user.name = "Subash Acharya";
    user.email = "hubert3158@gmail.com";
    core.editor = "vim";
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

    preload =
      [ "~/nixos/images/wallpaper.png" "" ];

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

  programs.wofi= {
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


    programs.eww = {
      enable = true;
      package = pkgs.eww;
      configDir = ./home-manager-config-files/eww;
    };

    services.gnome-keyring = {
      enable = true;
      components = [ "secrets"];
    };


    services.gpg-agent.enable = true;
    services.gpg-agent.enableZshIntegration = true;
    services.gpg-agent.enableSshSupport = true;

    services.gpg-agent.pinentryPackage = pkgs.pinentry-gnome3;


    programs.neomutt = {
      enable = true;
      editor = "nvim";
    };


    programs.zathura.enable = true;     #pdf viewer
    programs.mpv.enable = true;     #pdf viewer

    programs.rofi = {
      enable = true;
      theme = pkgs.rofi-theme-selector ;
    };

  }


