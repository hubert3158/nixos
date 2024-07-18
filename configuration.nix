# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs,lib, ... }:

{
# Include the results of the hardware scan.

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "nixos"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

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
  hardware.pulseaudio.enable = false;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  hardware.bluetooth.enable = true;
  security.rtkit.enable = true;

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.hubert = {
    isNormalUser = true;
    description = "hubert";
    extraGroups = [ "networkmanager" "wheel" "docker" "wireshark" "postgres"];
    packages = with pkgs; [
    #  kdePackages.kate
      thunderbird
    ];
  };

  # Install firefox.
  programs.firefox.enable = true;
  programs.steam.enable = true;

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    wayland
    wayland-protocols
    wl-clipboard
    xwayland
    xdg-desktop-portal
    xdg-desktop-portal-wlr
    swaybg
    swayidle                          # These are things needed for hyprland i guess lumaooooooooo
    swaylock
    mako
    hyprland
    hyprpaper
egl-wayland
    xorg.xrandr    
    weston
    alacritty
    polkit
    rofi
    grim
    slurp
    dmenu
    lightdm
    wofi



    vim 
    lsof
    wget 
    xclip
    curl
    git
    zsh
    oh-my-zsh
    zsh-autosuggestions
    home-manager
    maven
    jdk11
    jdk21
    gcc
    gnumake 
    nix-index
    util-linux
devbox
tree
sqlite
neovim
fzf
nodejs

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
  system.stateVersion = "24.05"; # Did you read the comment?

nix.settings.experimental-features = ["nix-command" "flakes"];



environment.shells = with pkgs; [ zsh ];
 environment.variables = {
    JAVA_HOME = "${pkgs.jdk21}/lib/openjdk";
  };
    environment.shellInit = ''
    export JAVA_HOME=${pkgs.jdk21}/lib/openjdk
    export PATH=${pkgs.jdk21}/bin:$PATH
  '';
users.defaultUserShell = pkgs.zsh;
programs.zsh.enable = true;
programs.tmux.enable=true;

services.postgresql = {
  enable = true;
  package = pkgs.postgresql_15;  # or your desired version
  settings = {
    listen_addresses =lib.mkForce "*";
  };
  authentication = '' 
    host all all 0.0.0.0/0 md5
  '';
};
networking.firewall.allowedTCPPorts = [ 5432 ];


#things needed for hyprland i guess

services.dbus.enable  = true;




}
