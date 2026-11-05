#!/usr/bin/env bash
# One command to move everything forward:
#   1. nix flake update    — nixpkgs, home-manager, ...
#   2. nvfetcher           — custom packages in packages/nvfetcher.toml
#   3. kulala grammar      — follows the kulala.nvim nixpkgs ships
#   4. hypr-dynamic-cursors — follows upstream hyprpm.toml; waits if no pin exists
#   5. Claude skills/plugins — scripts/update-skills.sh; run on each machine
#
# Rebuild afterwards: sudo nixos-rebuild switch --flake ~/nixos

set -euo pipefail

REPO_DIR="$(cd "$(dirname "$0")/.." && pwd)"
cd "$REPO_DIR"

echo "==> nix flake update"
nix flake update

echo "==> nvfetcher"
nix shell --inputs-from . nixpkgs#nvfetcher nixpkgs#jq nixpkgs#curl \
  -c nvfetcher -c packages/nvfetcher.toml -o packages/_sources
git add packages/_sources  # flakes silently skip untracked files

echo "==> kulala grammar"
./scripts/update-kulala-grammar.sh

echo "==> hypr-dynamic-cursors"
# Not fatal: upstream usually lags new Hyprland releases.
./scripts/update-hypr-dynamic-cursors.sh ||
  echo "    no pin yet — keep the plugin disabled and retry later"

echo "==> playwright-driver (core-v3 e2e must pin this exact version)"
nix eval --raw --impure --expr \
  "(builtins.getFlake \"$REPO_DIR\").inputs.nixpkgs.legacyPackages.\${builtins.currentSystem}.playwright-driver.version"
echo

echo "==> Claude skills and plugins"
# Not fatal: a skill source being down shouldn't block the rebuild.
./scripts/update-skills.sh ||
  echo "    some skill updates failed — see above, retry with ./scripts/update-skills.sh"

echo
echo "Done. Rebuild: sudo nixos-rebuild switch --flake ~/nixos"
