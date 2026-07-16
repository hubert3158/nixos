#!/usr/bin/env bash
# theme-lint — guard against palette drift on the live-symlinked CSS surfaces.
#
# The .nix surfaces get the palette via the `palette` specialArg
# (lib/palette.nix), but waybar/ and swaync/ are live-edited CSS where any hex
# can sneak in. This script flags every 6-digit hex in those files that is not
# a Kanagawa Wave value from lib/palette.nix.
#
# Usage: scripts/theme-lint.sh   (exit 1 on drift)

set -euo pipefail
root="$(cd "$(dirname "$0")/.." && pwd)"
palette="$root/lib/palette.nix"

# all palette hexes, lowercased
mapfile -t pal < <(grep -oE '"#[0-9A-Fa-f]{6}"' "$palette" | tr -d '"' | tr 'A-F' 'a-f' | sort -u)

in_palette() {
    local needle=$1 h
    for h in "${pal[@]}"; do
        [[ $h == "$needle" ]] && return 0
    done
    return 1
}

fail=0
for css in "$root"/home-manager-config-files/{waybar,swaync}/*.css; do
    [ -e "$css" ] || continue
    while IFS=: read -r lineno line; do
        for hex in $(grep -oE '#[0-9A-Fa-f]{6}' <<<"$line" | tr 'A-F' 'a-f' | sort -u); do
            if ! in_palette "$hex"; then
                echo "DRIFT ${css#"$root"/}:$lineno: $hex not in lib/palette.nix"
                echo "      $(sed 's/^[[:space:]]*//' <<<"$line")"
                fail=1
            fi
        done
    done < <(grep -nE '#[0-9A-Fa-f]{6}' "$css" || true)
done

if [ "$fail" -eq 0 ]; then
    echo "theme-lint: clean — every CSS hex is Kanagawa Wave."
fi
exit "$fail"
