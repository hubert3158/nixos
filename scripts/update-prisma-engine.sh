#!/usr/bin/env bash
# Updates the prisma-schema-engine-static Nix package to match the
# Prisma version installed in the project.
#
# Usage:
#   ./update-prisma-engine.sh [path-to-backend]
#
# Defaults to ~/IdeaProjects/core-v3/backend if no path given.

set -euo pipefail

BACKEND_DIR="${1:-$HOME/IdeaProjects/core-v3/backend}"
PKG_FILE="$(dirname "$0")/../packages/prisma-schema-engine-static/default.nix"

if [[ ! -f "$PKG_FILE" ]]; then
  echo "Error: package file not found at $PKG_FILE"
  exit 1
fi

# Get version and engine commit from the project's installed Prisma
echo "Reading Prisma version from $BACKEND_DIR..."
PRISMA_VERSION=$(node -e "console.log(require('$BACKEND_DIR/node_modules/prisma/package.json').version)")

# Engine commit is embedded in the @prisma/engines-version dependency string inside the bundle
ENGINE_COMMIT=$(node -e "
const fs = require('fs');
const content = fs.readFileSync('$BACKEND_DIR/node_modules/prisma/build/index.js', 'utf8');
const match = content.match(/@prisma\/engines-version.*?(\b[a-f0-9]{40}\b)/);
console.log(match ? match[1] : '');
")

if [[ -z "$PRISMA_VERSION" || -z "$ENGINE_COMMIT" ]]; then
  echo "Error: could not determine Prisma version or engine commit"
  echo "  PRISMA_VERSION=$PRISMA_VERSION"
  echo "  ENGINE_COMMIT=$ENGINE_COMMIT"
  exit 1
fi

CURRENT_COMMIT=$(grep 'engineCommit =' "$PKG_FILE" | sed 's/.*"\(.*\)".*/\1/')
if [[ "$ENGINE_COMMIT" == "$CURRENT_COMMIT" ]]; then
  echo "Already up to date: Prisma $PRISMA_VERSION (engine $ENGINE_COMMIT)"
  exit 0
fi

echo "Updating: Prisma $PRISMA_VERSION (engine $ENGINE_COMMIT)"

# Verify the binary exists on CDN
URL="https://binaries.prisma.sh/all_commits/${ENGINE_COMMIT}/linux-static-x64/schema-engine.gz"
HTTP_CODE=$(curl -s -o /dev/null -w "%{http_code}" "$URL")
if [[ "$HTTP_CODE" != "200" ]]; then
  echo "Error: engine binary not found at $URL (HTTP $HTTP_CODE)"
  exit 1
fi

# Download and compute SRI hash
echo "Downloading and hashing..."
TMPFILE=$(mktemp)
curl -sL "$URL" -o "$TMPFILE"
HASH=$(nix hash file --type sha256 "$TMPFILE")
rm "$TMPFILE"

echo "  Hash: $HASH"

# Update the Nix file
sed -i "s|prismaVersion = \".*\"|prismaVersion = \"$PRISMA_VERSION\"|" "$PKG_FILE"
sed -i "s|engineCommit = \".*\"|engineCommit = \"$ENGINE_COMMIT\"|" "$PKG_FILE"
sed -i "s|hash = \"sha256-.*\"|hash = \"$HASH\"|" "$PKG_FILE"

echo "Updated $PKG_FILE"
echo "  prismaVersion = $PRISMA_VERSION"
echo "  engineCommit  = $ENGINE_COMMIT"
echo "  hash          = $HASH"
echo ""
echo "Run 'sudo nixos-rebuild switch --flake ~/nixos' to apply."
