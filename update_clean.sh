#!/usr/bin/env zsh
# Update flake inputs, rebuild, then clean old generations.
# Usage: ./update.sh [host]   (host defaults to this machine's flake target)
set -euo pipefail

# nixos-work -> work, nixos-home -> home
host="${1:-$(hostname | sed 's/^nixos-//')}"

# Deep clean — optional since automatic GC + store optimisation run weekly
# (modules.nix.gc / nix.optimise). Kept for manual "free space now" runs.
clean_all() {
    sudo nix-env -v --delete-generations +10 --profile ~/.local/state/nix/profiles/home-manager
    sudo nix-env -v --delete-generations +10 --profile /nix/var/nix/profiles/system
    sudo nix-collect-garbage -v -d
    sudo nix-store --optimise
}

nix flake update
sudo nixos-rebuild switch --flake .#"$host" --show-trace
clean_all

echo
echo "Done. Reboot recommended if the kernel or systemd changed."
