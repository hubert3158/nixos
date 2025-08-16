# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).
{
  pkgs,
  lib,
  ...
}: {
  nixpkgs.overlays = [
    (self: super: {
      noto-fonts-cjk = super.noto-fonts-cjk-sans;
      # utillinux = super.util-linux;
    })
  ];

  # Include the results of the hardware scan.

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.systemd-boot.configurationLimit = 20;
  boot.loader.efi.canTouchEfiVariables = true;

  # Enable perf_event_paranoid and kptr_restrict, for jprofiler
  boot.kernel.sysctl = {
    "kernel.perf_event_paranoid" = 1;
    "kernel.kptr_restrict" = 0;
  };

  networking.hostName = "nixos"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;
  nix.settings.download-buffer-size = 104857600; # 100MB
  networking.nameservers = [
    "1.1.1.1" # Cloudflare
    "1.0.0.1" # Cloudflare secondary
    "8.8.8.8" # Google
    "8.8.4.4" # Google secondary
  ];

  # Display manager and keymap
  services.xserver = {
    enable = true;
    xkb.layout = "us";
    xkb.variant = "";
  };
  services.displayManager.sddm.enable = true;
  services.envfs.enable = true;

  programs.hyprland.enable = true;
  programs.command-not-found.enable = false;

  hardware = {
    graphics = {
      enable = true;
      extraPackages = with pkgs; [
        vaapiIntel
        vaapiVdpau
        libvdpau
      ];
    };
    bluetooth.enable = true;
  };

  networking.firewall.allowedTCPPorts = [3000 8080 8081 993 5678 5432 5000 8083 8085 9990 4318 4317];

  # services.intune.enable = true;
  # Set your time zone.
  time.timeZone = "America/New_York";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };

  # Enable the X11 windowing system.
  # You can disable this if you're only using the Wayland session.

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  # hardware.pulseaudio.enable = false;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  security.rtkit.enable = true;

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.hubert = {
    isNormalUser = true;
    description = "hubert";
    extraGroups = ["networkmanager" "wheel" "docker" "wireshark" "postgres" "video"];
    packages = with pkgs; [
      kdePackages.kate
      # thunderbird
    ];
  };

  # Install firefox.
  programs.firefox.enable = true;
  programs.steam.enable = true;
  programs.hyprland.withUWSM = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget

  environment.systemPackages = with pkgs; [
    entr
    ffmpeg
    flameshot
    jq #lightweight commandline json parser
    fd #Simple, fast and user-friendly alternative to find
    jupyter
    cht-sh
    gnome-multi-writer

    eclipses.eclipse-jee

    dbeaver-bin
    # wpsoffice

    graphicsmagick
    git-credential-manager

    audit #Audit Library. eg ausyscall
    ngrok
    tesseract
    poppler
    poppler_utils

    pnpm # Fast, disk space efficient package manager for JavaScript

    go
    direnv

    autoAddDriverRunpath
    autoFixElfFiles
    # cudaPackages_12_2

    gzip
    ntp

    pipewire
    wayland
    wayland-protocols
    wl-clipboard
    xwayland
    xdg-desktop-portal
    xdg-desktop-portal-wlr
    swaybg
    swayidle # These are things needed for hyprland i guess lumaooooooooo
    swaylock
    mako
    hyprland
    hyprpaper
    hyprlock
    egl-wayland
    xorg.xrandr
    weston
    alacritty
    polkit
    grim
    slurp
    dmenu
    lightdm
    wofi
    gnome-keyring

    nodejs # Base Node.js (or a specific version like nodejs-18_x)
    nodePackages.nodemon
    nodePackages.eslint
    nodePackages.jsonlint
    nodePackages.serve
    nodePackages.prettier # Prettier CLI
    nodePackages.pm2
    nodePackages.ts-node
    nodePackages.htmlhint # HTML linter
    nodePackages.typescript

    # === Daemons ===
    prettierd
    eslint_d

    # === Language Servers & Other Linters ===
    vscode-langservers-extracted # LSP for HTML, CSS, JSON, ESLint
    nginx-language-server
    sourcekit-lsp # LSP for Swift and C-based languages
    semgrep # Static analysis
    sqls # SQL Language Server
    hadolint # Dockerfile linter (keep if you use it for linting)
    markdownlint-cli # markdown linter
    libxml2 #XML parsing library for C.

    nil

    # === Formatters ===
    stylua # Lua
    alejandra # Nix
    kulala-fmt # HTTP
    # astyle # C, C++, C#, Java formatter (clang-format is often preferred for C/C++)
    google-java-format # Java
    pgformatter # Provides pg_format for PostgreSQL
    shfmt # Shell scripts
    taplo # TOML
    dfmt # Dockerfile formatter (recommended over hadolint for formatting)
    sqlfluff # SQL formatter/linter
    # mdformat # Markdown formatter -> currently using prettier

    # --- C/C++ ---
    rocmPackages.llvm.clang-tools

    # --- Go ---
    go # Base Go installation (provides gofmt)
    gotools # Provides goimports

    # --- Python ---
    python3 # Or a specific version like python311
    python3Packages.isort
    python3Packages.black
    python3Packages.flake8

    # --- Rust ---
    # Option 1: Install rustup and manage toolchain components (rustfmt, rust-analyzer) via rustup
    # rustup
    # After installing rustup, run:
    # rustup default stable (or nightly)
    # rustup component add rustfmt
    # rustup component add rust-analyzer

    # Option 2: Install components directly via Nix (simpler if you don't need rustup's flexibility)
    rustfmt # Rust code formatter
    rustup # Rust toolchain manager (optional, but useful for managing toolchains)

    # --- Terraform ---
    terraform # Provides terraform fmt

    vscode-js-debug #JavaScript Debugger for Visual Studio Code
    vscode-extensions.firefox-devtools.vscode-firefox-debug #Firefox Debugger for Visual Studio Code
    # qutebrowser

    yarn

    vim
    zoxide
    lsof
    wget
    xclip
    kdePackages.konsole
    kdePackages.dolphin
    kdePackages.breeze-icons

    curl
    git
    zsh
    oh-my-zsh
    zsh-autosuggestions
    home-manager
    maven
    jdk11
    jdk21
    jdk24
    gcc
    gnumake
    nix-index
    util-linux
    zip
    unzip

    gnupg
    pinentry-all

    devbox
    tree
    sqlite
    fzf
    skim
    nodejs_22
    ranger

    inotify-tools # help watch a file and reload when it changes
    # gtkmm3
    # upower
    # cacert
    evolution
    evolution-ews
    pass
    age
    zoxide

    rofi

    i3 # tiling window manager for x11

    pyright #Type checker for the Python language.

    clang
    ccls
    libclang #c , cpp , c++
    glibc.dev # installed dev , has c system headers like stdio.h

    sonar-scanner-cli

    zellij
    slack

    qpdf
    usbutils
    balena-cli
    zsh-powerlevel10k
    w3m
    wikiman
    tealdeer #rust imp of tldr
    parallel
    # prisma
    # prisma-engines
    openssl
    sshpass
    postman
    libreoffice
  ];
  virtualisation.docker.enable = true;
  #services.docker.enable = true;

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.11"; # Did you read the comment?

  nix.settings.experimental-features = ["nix-command" "flakes"];

  environment.shells = with pkgs; [zsh];
  environment.variables = {
    JAVA_HOME = "${pkgs.jdk24}/lib/openjdk";
    JAVA_HOME11 = "${pkgs.jdk11}/lib/openjdk";
    JAVA_HOME21 = "${pkgs.jdk21}/lib/openjdk";
    JAVA_HOME24 = "${pkgs.jdk24}/lib/openjdk";
  };

  environment.shellInit = ''
        export PATH=$JAVA_HOME/bin:$PATH
        export SSH_AUTH_SOCK=$(gpgconf --list-dirs agent-ssh-socket)

        export PRISMA_SCHEMA_ENGINE_BINARY='/nix/store/zvhb5bj7xbwr55avrimyv7pzxxyw9skj-prisma-engines-6.7.0/bin/schema-engine'
    export PRISMA_QUERY_ENGINE_BINARY='/nix/store/zvhb5bj7xbwr55avrimyv7pzxxyw9skj-prisma-engines-6.7.0/bin/query-engine'
    export PRISMA_QUERY_ENGINE_LIBRARY='/nix/store/zvhb5bj7xbwr55avrimyv7pzxxyw9skj-prisma-engines-6.7.0/lib/libquery_engine.node'

  '';

  users.defaultUserShell = pkgs.zsh;
  programs.zsh.enable = true;
  programs.fish.enable = true;
  programs.tmux.enable = true;
  programs.java.enable = true;
  programs.java.package = pkgs.jdk24;

  services.postgresql = {
    enable = true;
    package = pkgs.postgresql_15; # or your desired version
    settings = {
      listen_addresses = lib.mkForce "*";
    };
    authentication = ''
      host all all 0.0.0.0/0 md5
    '';
  };
  #things needed for hyprland i guess and i was wrong i guess idk
  services.dbus.enable = true;
  environment.sessionVariables = {
    #Hint electron apps to use wayland
    NIXOS_OZONE_WL = "1";

    EDITOR = "nvim";
    PAGER = "less";
    BROWSER = "firefox";
    FILE_MANAGER = "ranger";
    PDF_VIEWER = "zathura";
    MUSIC_PLAYER = "mpv";
    TERMINAL = "alacritty";
  };
  xdg.portal.enable = true;
  xdg.portal.extraPortals = [pkgs.xdg-desktop-portal-gtk];

  programs.neovim.enable = true;

  services.gnome.gnome-keyring = {
    enable = true;
  };

  services.flatpak.enable = true;

  services.dbus.packages = [pkgs.gcr];
  services.pcscd.enable = true;
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
    settings = {
      default-cache-ttl = 600;
    };
  };

  fonts.packages = with pkgs; [
    nerd-fonts.fira-code
    corefonts
    noto-fonts
    noto-fonts-cjk
    noto-fonts-emoji
    liberation_ttf
    fira-code
    fira-code-symbols
    mplus-outline-fonts.githubRelease
    dina-font
    proggyfonts
  ];
}
