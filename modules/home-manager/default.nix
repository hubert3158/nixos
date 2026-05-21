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
  };
}
