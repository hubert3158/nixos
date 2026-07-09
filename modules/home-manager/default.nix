# Home-Manager modules aggregator
{ config, lib, pkgs, ... }:

{
  imports = [
    ./shell
    ./terminals
    ./desktop
    ./programs
    ./file-managers
    ./tools
    ./packages.nix
  ];

  # Base home-manager configuration
  home.stateVersion = "24.11";
  home.username = "hubert";
  home.homeDirectory = "/home/hubert";

  # Note: nixpkgs.config is set at the flake level when using useGlobalPkgs

  # Cursor theme — consistent across Hyprland, GTK, and XWayland
  home.pointerCursor = {
    package = pkgs.bibata-cursors;
    name = "Bibata-Modern-Ice";
    size = 24;
    gtk.enable = true;
    x11.enable = true;
  };

  # Dark GTK apps (pavucontrol, file pickers) + icon theme for fuzzel/dolphin
  gtk = {
    enable = true;
    theme = {
      name = "adw-gtk3-dark";
      package = pkgs.adw-gtk3;
    };
    iconTheme = {
      name = "Papirus-Dark";
      package = pkgs.papirus-icon-theme;
    };
    gtk3.extraConfig.gtk-application-prefer-dark-theme = 1;
    gtk4.extraConfig.gtk-application-prefer-dark-theme = 1;
    # adw-gtk3 is a GTK3-only theme; GTK4/libadwaita apps style themselves.
    # null = new HM 26.05 default (silences legacy-default eval warning).
    gtk4.theme = null;
  };

  # Qt apps (dolphin, qt file dialogs) follow the dark GTK look instead of
  # rendering unthemed-light next to everything else
  qt = {
    enable = true;
    platformTheme.name = "adwaita";
    style.name = "adwaita-dark";
    style.package = with pkgs; [ adwaita-qt adwaita-qt6 ];
  };

  # Session variables
  home.sessionVariables = {
    PATH = "$HOME/.local/bin:$HOME/.npm-global/bin:$PATH";
    NPM_CONFIG_PREFIX = "$HOME/.npm-global";
    # Force Node.js to prefer IPv4 — fixes Claude Code OAuth login on NixOS
    # (Node binds to IPv6 ::1 but browser hits IPv4 127.0.0.1, causing timeout)
    NODE_OPTIONS = "--dns-result-order=ipv4first";
    # Playwright E2E testing — use Nix-provided browsers
    PLAYWRIGHT_BROWSERS_PATH = "${pkgs.playwright-driver.browsers}";
    # nvim-jdtls — point at nix-packaged jdtls + bundles (replaces mason)
    JDTLS_PATH = "${pkgs.jdt-language-server}/share/java/jdtls";
    JDTLS_JAVA_DEBUG_BUNDLE_DIR = "${pkgs.vscode-extensions.vscjava.vscode-java-debug}/share/vscode/extensions/vscjava.vscode-java-debug/server";
    JDTLS_JAVA_TEST_BUNDLE_DIR = "${pkgs.vscode-extensions.vscjava.vscode-java-test}/share/vscode/extensions/vscjava.vscode-java-test/server";
    # rustaceanvim DAP — codelldb adapter dir (read in nvim/lua/user/rustaceanvim.lua).
    # Interpolating the store path pins the package as a dependency; no PATH entry needed.
    CODELLDB_PATH = "${pkgs.vscode-extensions.vadimcn.vscode-lldb}/share/vscode/extensions/vadimcn.vscode-lldb";
  };

  # kulala.nvim backend (kulala-core) — provides the HTTP-file LSP that powers
  # completion/diagnostics/hover. nixpkgs patches the plugin's kulala_core.path to
  # point at pkgs.kulala-core and disables the GitHub auto-download (downloaded
  # binaries don't run on NixOS, and nothing here auto-updates by design — the
  # version is pinned to whatever nixpkgs ships). But the plugin's LSP start gate
  # (Backend.is_up_to_date) only checks the *download* location, ignoring the
  # configured path, so the LSP never attaches and completion silently dies.
  # Symlinking the nix binary into that expected download path satisfies the gate.
  # Same binary nixpkgs already wires as kulala_core.path, so run + gate agree.
  home.file.".local/share/nvim/kulala.nvim/bin/kulala-core".source =
    "${pkgs.kulala-core}/bin/kulala-core";
}
