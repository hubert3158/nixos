# Shell modules aggregator
{ ... }:

{
  imports = [
    ./zsh.nix
    ./fish.nix
    ./starship.nix
    ./aliases.nix
  ];
}
