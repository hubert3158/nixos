# Common configuration shared by all hosts
{
  config,
  lib,
  pkgs,
  inputs,
  ...
}: {
  # ============================================================================
  # ENABLE ALL MODULES
  # ============================================================================

  # Boot configuration
  modules.boot = {
    enable = true;
    loader = "systemd-boot";
    configurationLimit = 20;
    enableJProfiler = true;
  };

  # Networking
  modules.networking = {
    enable = true;
    hostName = "nixos";
    enableNetworkManager = true;
    nameservers = ["1.1.1.1" "1.0.0.1" "8.8.8.8" "8.8.4.4"];
  };

  # Locale
  modules.locale = {
    enable = true;
    timeZone = "America/New_York";
    defaultLocale = "en_US.UTF-8";
  };

  # Users
  modules.users = {
    enable = true;
    username = "hubert";
    description = "hubert";
    extraGroups = ["networkmanager" "wheel" "docker" "wireshark" "postgres" "video"];
    defaultShell = pkgs.zsh;
  };

  # Security
  modules.security = {
    enable = true;
    enableRtkit = true;
    enablePolkit = true;
    enableGnomeKeyring = true;
    enableGpgAgent = true;
    gpgCacheTtl = 600;
  };

  # Nix settings
  modules.nix = {
    enable = true;
    enableFlakes = true;
    stateVersion = "24.11";
  };

  # ============================================================================
  # DESKTOP MODULES
  # ============================================================================

  modules.desktop.sddm = {
    enable = true;
    enableXserver = true;
    xkbLayout = "us";
  };

  modules.desktop.hyprland = {
    enable = true;
    withUWSM = true;
  };

  modules.desktop.i3.enable = true;

  # ============================================================================
  # HARDWARE MODULES
  # ============================================================================

  modules.hardware.audio = {
    enable = true;
    enableAlsa = true;
    enableAlsa32Bit = true;
    enablePulse = true;
    enableJack = true;
  };

  modules.hardware.bluetooth.enable = true;

  modules.hardware.graphics = {
    enable = true;
    enableVdpau = true;
  };

  # ============================================================================
  # SERVICES MODULES
  # ============================================================================

  modules.services.docker.enable = true;

  modules.services.postgresql = {
    enable = true;
    package = pkgs.postgresql_15;
    listenAddresses = "*";
    enableRemoteAccess = true;
  };

  modules.services.openssh.enable = true;
  modules.services.flatpak.enable = true;
  modules.services.printing.enable = true;

  # ============================================================================
  # DEVELOPMENT MODULES
  # ============================================================================

  modules.development.languages = {
    enable = true;
    enableNode = true;
    enablePython = true;
    enableGo = true;
    enableRust = true;
    enableJava = true;
    enableC = true;
  };

  modules.development.tools = {
    enable = true;
    enableLSP = true;
    enableFormatters = true;
    enableDebuggers = true;
    enableNeovim = true;
    enableTerraform = true;
    enableWireshark = true;
    enablePrisma = true;
  };

  # ============================================================================
  # ADDITIONAL SYSTEM CONFIGURATION
  # ============================================================================

  # Enable shells
  programs.zsh.enable = true;
  programs.fish.enable = true;
  programs.tmux.enable = true;

  # Steam
  programs.steam.enable = true;

  # Disable command-not-found (using nix-index instead)
  programs.command-not-found.enable = false;

  # NetworkManager applet
  programs.nm-applet.enable = true;

  # Fonts
  fonts.packages = with pkgs; [
    nerd-fonts.fira-code
    corefonts
    noto-fonts
    noto-fonts-color-emoji
    liberation_ttf
    fira-code
    fira-code-symbols
    mplus-outline-fonts.githubRelease
    dina-font
    proggyfonts
  ];

  # Additional system packages not covered by modules
  environment.systemPackages = with pkgs; [
    # Terminal emulators
    alacritty
    kdePackages.konsole

    # File managers
    kdePackages.dolphin
    kdePackages.breeze-icons
    ranger

    # Media & documents
    ffmpeg
    flameshot
    typst
    tinymist
    jupyter
    cht-sh

      # Misc tools
      asciinema
      asciinema-agg
      gnome-multi-writer
      graphicsmagick
      git-credential-manager
      tesseract
      poppler
      poppler-utils
      ntp
      weston
      lightdm
      w3m
      wikiman
      tealdeer
      postman
      networkmanagerapplet
      miller
      kdePackages.kdenlive
      inetutils
      gopass

    # IDE
    eclipses.eclipse-jee
    dbeaver-bin

    # Communication
    slack

    # Other
    qpdf
    usbutils
    balena-cli
    zsh-powerlevel10k
    zellij
    claude-code

    awscli
    antigravity
  ];

  # Environment shells
  environment.shells = with pkgs; [zsh];
}
