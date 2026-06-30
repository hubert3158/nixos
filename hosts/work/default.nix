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
    tunnelId = "aa1284a7-4a1d-489c-9109-1a0863009a9c";
    hostname = "bluetangles.com";
  };
}
