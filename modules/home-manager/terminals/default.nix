# Terminal modules aggregator
{ ... }:

{
  imports = [
    ./wezterm.nix
    ./kitty.nix
    ./ghostty.nix
  ];
}
