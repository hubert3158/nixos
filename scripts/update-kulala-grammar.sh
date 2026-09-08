#!/usr/bin/env bash
# Resyncs the kulala_http tree-sitter grammar pin in packages/neovim/default.nix
# with whatever rev the kulala.nvim plugin in this flake's nixpkgs pins.
#
# kulala.nvim stops bundling the grammar as of 6.15.x: it records a grammar rev in
# lua/kulala/globals/versions/treesitter.lua and clones+builds it at runtime, which
# cannot work on NixOS. We pre-build that exact rev instead, so the pin must follow
# the plugin — never upstream HEAD.
#
# Usage:
#   ./update-kulala-grammar.sh          # bump the pin if it drifted
#   ./update-kulala-grammar.sh --check  # report drift only, exit 1 if stale

set -euo pipefail

CHECK_ONLY=0
[[ "${1:-}" == "--check" ]] && CHECK_ONLY=1

REPO_DIR="$(cd "$(dirname "$0")/.." && pwd)"
NIX_FILE="$REPO_DIR/packages/neovim/default.nix"
VERSIONS_DIR="lua/kulala/globals/versions"

if [[ ! -f "$NIX_FILE" ]]; then
  echo "Error: $NIX_FILE not found"
  exit 1
fi

# Build the plugin from the nixpkgs this flake is locked to (not the registry).
echo "Resolving vimPlugins.kulala-nvim from the flake's nixpkgs..."
PLUGIN=$(nix build --no-link --print-out-paths \
  --inputs-from "$REPO_DIR" nixpkgs#vimPlugins.kulala-nvim)

TS_FILE="$PLUGIN/$VERSIONS_DIR/treesitter.lua"
PLUGIN_FILE="$PLUGIN/$VERSIONS_DIR/plugin.lua"

if [[ ! -f "$TS_FILE" ]]; then
  echo "Error: $VERSIONS_DIR/treesitter.lua missing from the plugin."
  echo "  Upstream may have moved the grammar pin — check $PLUGIN/$VERSIONS_DIR"
  exit 1
fi

REV=$(grep -oE '[0-9a-f]{40}' "$TS_FILE" | head -1)
PLUGIN_VERSION=$(grep -oE '"[^"]+"' "$PLUGIN_FILE" | tr -d '"' | head -1)
CURRENT_REV=$(sed -n '/kulalaGrammarPin = {/,/};/p' "$NIX_FILE" \
  | grep -oE '[0-9a-f]{40}' | head -1)

if [[ -z "$REV" || -z "$PLUGIN_VERSION" || -z "$CURRENT_REV" ]]; then
  echo "Error: could not read all three values"
  echo "  plugin rev     = $REV"
  echo "  plugin version = $PLUGIN_VERSION"
  echo "  pinned rev     = $CURRENT_REV"
  exit 1
fi

if [[ "$REV" == "$CURRENT_REV" ]]; then
  echo "Already current: kulala.nvim $PLUGIN_VERSION, grammar $REV"
  exit 0
fi

echo "Drift: kulala.nvim $PLUGIN_VERSION pins $REV, flake pins $CURRENT_REV"
if [[ "$CHECK_ONLY" == 1 ]]; then
  echo "Run without --check to bump."
  exit 1
fi

URL="https://github.com/mistweaverco/tree-sitter-kulala-http/archive/$REV.tar.gz"
echo "Hashing $URL ..."
HASH=$(nix-prefetch-url --unpack "$URL" 2>/dev/null | tail -1 \
  | xargs -I{} nix hash convert --hash-algo sha256 --to sri {})

if [[ -z "$HASH" ]]; then
  echo "Error: prefetch failed for $URL"
  exit 1
fi

# Only touch the generated attrset, never the rest of the file.
sed -i "/kulalaGrammarPin = {/,/};/ {
  s|pluginVersion = \"[^\"]*\"|pluginVersion = \"$PLUGIN_VERSION\"|
  s|rev = \"[^\"]*\"|rev = \"$REV\"|
  s|hash = \"[^\"]*\"|hash = \"$HASH\"|
}" "$NIX_FILE"

echo "Updated $NIX_FILE"
echo "  pluginVersion = $PLUGIN_VERSION"
echo "  rev           = $REV"
echo "  hash          = $HASH"
echo ""
echo "Run 'sudo nixos-rebuild switch --flake ~/nixos' to apply."
