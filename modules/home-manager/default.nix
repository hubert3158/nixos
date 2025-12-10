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
    PATH = "$HOME/.local/bin:$PATH";
  };
}
