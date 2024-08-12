
{ pkgs, ... }:
  {
  imports = [
    ./home-manager-config-files/common.nix
    ./home-manager-config-files/i3.nix
  ];
  }


