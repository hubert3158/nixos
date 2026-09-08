#!/usr/bin/env bash
# Resyncs the hypr-dynamic-cursors pin in modules/home-manager/desktop/hyprland.nix
# with the rev upstream's hyprpm.toml pins to the Hyprland version this flake ships.
#
# The plugin resolves Hyprland internals by function signature at init, so a rev
# built for a different Hyprland throws at load and Hyprland paints a red
# "unexpected function signature" overlay. Upstream tracks the correct pairing in
# hyprpm.toml `commit_pins`; nixpkgs' own pin routinely lags behind it. Never use
# the plugin's HEAD — it tracks Hyprland git main and won't compile against a release.
#
# Usage:
#   ./update-hypr-dynamic-cursors.sh          # bump the pin if it drifted
#   ./update-hypr-dynamic-cursors.sh --check  # report drift only, exit 1 if stale

set -euo pipefail

CHECK_ONLY=0
[[ "${1:-}" == "--check" ]] && CHECK_ONLY=1

REPO_DIR="$(cd "$(dirname "$0")/.." && pwd)"
NIX_FILE="$REPO_DIR/modules/home-manager/desktop/hyprland.nix"
HYPRPM_URL="https://raw.githubusercontent.com/VirtCode/hypr-dynamic-cursors/main/hyprpm.toml"
REPO_URL="https://github.com/VirtCode/hypr-dynamic-cursors"

command -v jq >/dev/null || { echo "Error: jq required"; exit 1; }
[[ -f "$NIX_FILE" ]] || { echo "Error: $NIX_FILE not found"; exit 1; }

# Hyprland version + nixpkgs' own plugin rev, from this flake's locked nixpkgs.
read -r HYPR_VERSION NIXPKGS_REV <<<"$(nix eval --raw --impure --expr "
  let f = builtins.getFlake \"$REPO_DIR\";
      p = f.inputs.nixpkgs.legacyPackages.\${builtins.currentSystem};
  in \"\${p.hyprland.version} \${p.hyprlandPlugins.hypr-dynamic-cursors.src.rev}\"")"

echo "Hyprland in this flake: $HYPR_VERSION (nixpkgs plugin rev: ${NIXPKGS_REV:0:7})"

# Upstream's pin table: one line per Hyprland release, trailing "# vX.Y.Z" comment.
PIN_LINE=$(curl -sf "$HYPRPM_URL" | grep -E "#[[:space:]]*v${HYPR_VERSION}[[:space:]]*$" || true)
if [[ -z "$PIN_LINE" ]]; then
  echo "Error: upstream hyprpm.toml has no commit_pins entry for Hyprland v$HYPR_VERSION"
  echo "  Upstream has not caught up yet — keep the current pin and retry later:"
  echo "  $HYPRPM_URL"
  exit 1
fi

# Second hash on the line is the plugin rev (first is the Hyprland commit).
REV=$(grep -oE '[0-9a-f]{40}' <<<"$PIN_LINE" | sed -n '2p')
CURRENT_REV=$(sed -n '/dynamicCursorsPin = {/,/};/p' "$NIX_FILE" | grep -oE '[0-9a-f]{40}' | head -1)
CURRENT_HYPR=$(sed -n '/dynamicCursorsPin = {/,/};/p' "$NIX_FILE" \
  | sed -n 's|.*hyprlandVersion = "\([^"]*\)".*|\1|p')

if [[ -z "$REV" || -z "$CURRENT_REV" ]]; then
  echo "Error: could not read revs (upstream=$REV pinned=$CURRENT_REV)"
  exit 1
fi

if [[ "$NIXPKGS_REV" == "$REV" ]]; then
  echo "nixpkgs now ships the correct rev — the overrideAttrs block in"
  echo "  $NIX_FILE"
  echo "is redundant and can be deleted (use pkgs.hyprlandPlugins.hypr-dynamic-cursors directly)."
fi

if [[ "$REV" == "$CURRENT_REV" && "$HYPR_VERSION" == "$CURRENT_HYPR" ]]; then
  echo "Already current: Hyprland $HYPR_VERSION → plugin $REV"
  exit 0
fi

echo "Drift: Hyprland $HYPR_VERSION wants $REV, flake pins $CURRENT_REV (for $CURRENT_HYPR)"
if [[ "$CHECK_ONLY" == 1 ]]; then
  echo "Run without --check to bump."
  exit 1
fi

# version string mirrors nixpkgs' convention: 0-unstable-<commit date>
COMMIT_DATE=$(curl -sf "https://api.github.com/repos/VirtCode/hypr-dynamic-cursors/commits/$REV" \
  | jq -r '.commit.committer.date[0:10]')
[[ -n "$COMMIT_DATE" && "$COMMIT_DATE" != "null" ]] || { echo "Error: could not read commit date for $REV"; exit 1; }

echo "Hashing $REPO_URL @ $REV ..."
HASH=$(nix-prefetch-url --unpack "$REPO_URL/archive/$REV.tar.gz" 2>/dev/null | tail -1 \
  | xargs -I{} nix hash convert --hash-algo sha256 --to sri {})
[[ -n "$HASH" ]] || { echo "Error: prefetch failed"; exit 1; }

# Only touch the generated attrset.
sed -i "/dynamicCursorsPin = {/,/};/ {
  s|hyprlandVersion = \"[^\"]*\"|hyprlandVersion = \"$HYPR_VERSION\"|
  s|version = \"0-unstable-[^\"]*\"|version = \"0-unstable-$COMMIT_DATE\"|
  s|rev = \"[^\"]*\"|rev = \"$REV\"|
  s|hash = \"[^\"]*\"|hash = \"$HASH\"|
}" "$NIX_FILE"

echo "Updated $NIX_FILE"
echo "  hyprlandVersion = $HYPR_VERSION"
echo "  version         = 0-unstable-$COMMIT_DATE"
echo "  rev             = $REV"
echo "  hash            = $HASH"
echo ""
echo "Run 'sudo nixos-rebuild switch --flake ~/nixos' to apply."
