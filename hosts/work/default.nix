# Work host configuration
{ config, lib, pkgs, inputs, ... }:

{
  imports = [
    ../common
    ./hardware.nix
  ];

  # Override hostname for work machine
  networking.hostName = lib.mkForce "nixos-work";

  # Java profiling happens on this machine (relaxes kptr_restrict)
  modules.boot.enableJProfiler = true;

  # Dev tunnel (vite on :5173) — runs on this machine only
  modules.services.cloudflared = {
    enable = true;
    tunnelId = "ba201dbf-cdd7-4a39-af75-6bb37bcc4db0";
    hostname = "dev.subash.us.kg";
  };
}
