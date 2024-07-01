{ pkgs, ... }:
{
  home.stateVersion = "24.05";  # Use the latest stable version number that aligns with your Home Manager version
  home.username="hubert";
  home.homeDirectory="/home/hubert";
  # Centralized package definitions
  home.packages = with pkgs; [
    # List your packages here
neovim
    # Additional packages...
  ];
}
