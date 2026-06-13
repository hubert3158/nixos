# Common configuration shared by all hosts
{pkgs, ...}: let
  cocoindex = pkgs.callPackage ../../packages/cocoindex {};
  ccline = pkgs.callPackage ../../packages/ccline {};
  sigmap = pkgs.callPackage ../../packages/sigmap {};
in {
  # ============================================================================
  # ENABLE ALL MODULES
  # ============================================================================

  # Boot configuration
  modules.boot = {
    enable = true;
    loader = "systemd-boot";
    configurationLimit = 20;
    # enableJProfiler set per-host (relaxes kernel hardening)
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
    gc.enable = true; # weekly, --delete-older-than 30d
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
    # localhost-only listen + default pg_hba (module defaults)
  };

  modules.services.openssh.enable = true;
  modules.services.flatpak.enable = true;
  modules.services.printing.enable = true;
  # cloudflared is enabled per-host (tunnel id/hostname live in the host config)

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
  fonts.fontDir.enable = true;
  fonts.packages = with pkgs; [
    nerd-fonts.fira-code
    nerd-fonts.jetbrains-mono
    corefonts
    noto-fonts
    noto-fonts-cjk-sans
    noto-fonts-cjk-serif
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
    # Terminals: kitty/wezterm/ghostty are home-manager modules
    kitty.terminfo

    # File managers: ranger + yazi (yazi via home-manager module)
    kdePackages.breeze-icons # icon theme for Qt apps
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
    w3m
    wikiman
    tealdeer
    postman
    networkmanagerapplet
    miller
    # kdePackages.kdenlive
    inetutils
    gopass

    # IDE (heavy Java IDEs live behind modules.packages.enableJetbrains)
    dbeaver-bin

    # Communication
    slack

    # Other
    qpdf
    usbutils
    balena-cli
    zsh-powerlevel10k
    zellij

    awscli2
    # antigravity
    libmaxminddb
    # claude-desktop-fhs  # disabled: upstream patches (aaddrick) fail against Claude Desktop 1.9659.2 — addTrustedFolder anchor + #412 spawn regex no longer match. Re-enable when aaddrick/claude-desktop-debian updates.

    # AI / Claude Code tooling — replaces previous npm-global installs.
    claude-code # @anthropic-ai/claude-code CLI
    ccline # @cometix/ccline statusline (custom pkg, Rust binary)
    cocoindex # incremental indexing engine for agents (Python+Rust)
    sigmap # AI context engine CLI (gen-context / gen-project-map)
  ];

  # Environment shells
  environment.shells = with pkgs; [zsh];

  # ============================================================================
  # SYSTEM MAINTENANCE & PERFORMANCE
  # ============================================================================

  # Compressed RAM swap — the work machine has no disk swap at all;
  # without this a single OOM kills the session.
  zramSwap = {
    enable = true;
    memoryPercent = 50;
  };

  # Periodic SSD TRIM
  services.fstrim.enable = true;

  # Don't let /tmp accumulate across boots
  boot.tmp.cleanOnBoot = true;

  # Skip rebuilding the NixOS options manual — it regenerates whenever
  # custom module options change (often, in this repo)
  documentation.nixos.enable = false;
}
