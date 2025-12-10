# Home host configuration
{ config, lib, pkgs, inputs, ... }:

{
  imports = [
    ../common
    ./hardware.nix
  ];

  # Override hostname for home machine
  networking.hostName = lib.mkForce "nixos-home";

  # Home-specific configuration can go here
  # For example, gaming packages, personal tools, etc.
}
