# Desktop modules aggregator
{ ... }:

{
  imports = [
    ./hyprland.nix
    ./hyprlock.nix
    ./hyprpaper.nix
    ./i3.nix
    ./xdg.nix
    ./fuzzel.nix
    ./flameshot.nix
  ];
}
