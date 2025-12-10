# Services modules aggregator
{ ... }:

{
  imports = [
    ./docker.nix
    ./postgresql.nix
    ./openssh.nix
    ./flatpak.nix
    ./printing.nix
  ];
}
