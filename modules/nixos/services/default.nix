# Services modules aggregator
{ ... }:

{
  imports = [
    ./cloudflared.nix
    ./docker.nix
    ./postgresql.nix
    ./openssh.nix
    ./flatpak.nix
    ./printing.nix
  ];
}
