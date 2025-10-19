clean-all
nix flake update
sudo nixos-rebuild switch --flake .#home --upgrade --show-trace
clean-all
reboot
