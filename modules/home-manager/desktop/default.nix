# Desktop modules aggregator
{ ... }:

{
  imports = [
    ./hyprland.nix
    ./hyprlock.nix
    ./hypridle.nix
    ./hyprpaper.nix
    ./swww.nix
    ./swayosd.nix
    ./i3.nix
    ./xdg.nix
    ./fuzzel.nix
    ./flameshot.nix
    ./waybar.nix
    ./swaync.nix
    ./wlogout.nix
  ];
}
