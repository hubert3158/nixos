# NixOS modules aggregator
{ ... }:

{
  imports = [
    ./boot.nix
    ./networking.nix
    ./locale.nix
    ./users.nix
    ./security.nix
    ./nix-settings.nix
    ./secrets.nix

    # Submodule directories
    ./desktop
    ./hardware
    ./services
    ./development
  ];
}
