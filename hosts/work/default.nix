# Work host configuration
{ config, lib, pkgs, inputs, ... }:

{
  imports = [
    ../common
    ./hardware.nix
  ];

  # Override hostname for work machine
  networking.hostName = lib.mkForce "nixos-work";

  # Work-specific configuration can go here
  # For example, you might want different firewall rules, etc.
}
