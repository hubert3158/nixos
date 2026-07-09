# Work host configuration
{
  config,
  lib,
  pkgs,
  inputs,
  ...
}: {
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
    tunnelId = "bd3c97f4-586f-40f6-8a4c-cb90fde6f9a4";
    hostname = "dev.bluetangles.com";
  };
}
