#!/usr/bin/env zsh

clean_all() {
    sudo nix-env -v --delete-generations +10 --profile ~/.local/state/nix/profiles/home-manager &&
        sudo nix-env -v --delete-generations +10 --profile /nix/var/nix/profiles/system &&
        sudo nix-collect-garbage -v -d &&
        sudo nix-store --optimise
}


clean_all
sleep 5
nix flake update
sleep 5
sudo nixos-rebuild switch --flake .#home --upgrade --show-trace
sleep 5
clean-all
sleep 5
reboot
