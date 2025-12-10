# Hardware modules aggregator
{ ... }:

{
  imports = [
    ./audio.nix
    ./bluetooth.nix
    ./graphics.nix
  ];
}
