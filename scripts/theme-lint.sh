#!/usr/bin/env bash
# theme-lint — guard against Kanagawa palette drift across every themed surface.
#
# lib/palette.nix is the machine-readable source of truth (docs/THEME.md is its
# human twin). This script flags any colour literal, anywhere in the repo, that
# is not one of those values.
#
# Surfaces covered:
#   *.css   home-manager-config-files/{waybar,swaync}  (live-symlinked, hand-edited)
#   *.conf  dotfiles/hypr                              (live-sourced hyprland)
#   *.nix   modules/, hosts/, lib/                     (also catches inline CSS)
#   *.lua   nvim/                                      (plugin fallback colours)
#
# Literal forms understood:
#   #RRGGBB        css / nix / lua / kitty / starship
#   ##RRGGBB       pango markup inside hyprlang (hyprlock placeholder_text)
#   rgb(RRGGBB)    hyprland / hyprlock
#   rgba(RRGGBBAA) hyprland / hyprlock  (alpha byte stripped before comparison)
#
# A '#' glued to a word character is treated as an issue reference, not a
# colour (e.g. rust-lang/rust#141402), and skipped.
#
# Escape hatch: append '# theme-lint: allow' to a line to exempt it.
#
# Usage: scripts/theme-lint.sh   (exit 1 on drift)

set -euo pipefail
root="$(cd "$(dirname "$0")/.." && pwd)"
palette="$root/lib/palette.nix"

# every palette hex, lowercased, no '#'
mapfile -t pal < <(grep -oE '"#[0-9A-Fa-f]{6}"' "$palette" | tr -d '"#' | tr 'A-F' 'a-f' | sort -u)

in_palette() {
    local needle=$1 h
    # fully transparent is "absent", not a colour
    [[ $needle == "00000000" || $needle == "000000" ]] && return 0
    for h in "${pal[@]}"; do
        [[ $h == "$needle" ]] && return 0
    done
    return 1
}

# Collect the files to scan. Only tracked files — untracked scratch copies
# aren't part of the config (and nix wouldn't see them anyway).
mapfile -t files < <(
    cd "$root" && git ls-files \
        'home-manager-config-files/*.css' \
        'dotfiles/hypr/*.conf' \
        'modules/*.nix' \
        'hosts/*.nix' \
        'lib/*.nix' \
        'nvim/*.lua' \
    | grep -v '^lib/palette\.nix$'
)

fail=0
for rel in "${files[@]}"; do
    file="$root/$rel"
    [ -e "$file" ] || continue
    while IFS=: read -r lineno line; do
        [[ $line == *"theme-lint: allow"* ]] && continue

        # rgb(RRGGBB) / rgba(RRGGBBAA) — hyprland colour literals
        for hex in $(grep -oiE 'rgba?\([0-9A-F]{6,8}\)' <<<"$line" \
                     | grep -oiE '[0-9A-F]{6,8}' | tr 'A-F' 'a-f' | sort -u); do
            # drop the alpha byte from the 8-digit form
            [ "${#hex}" -eq 8 ] && [ "$hex" != "00000000" ] && hex="${hex:0:6}"
            if ! in_palette "$hex"; then
                echo "DRIFT $rel:$lineno: rgb($hex) not in lib/palette.nix"
                echo "      $(sed 's/^[[:space:]]*//' <<<"$line")"
                fail=1
            fi
        done

        # #RRGGBB / ##RRGGBB — skip issue refs like rust#141402 by requiring
        # the character before '#' to not be a word character
        for hex in $(grep -oiE '(^|[^0-9A-Za-z_])#{1,2}[0-9A-F]{6}\b' <<<"$line" \
                     | grep -oiE '[0-9A-F]{6}$' | tr 'A-F' 'a-f' | sort -u); do
            if ! in_palette "$hex"; then
                echo "DRIFT $rel:$lineno: #$hex not in lib/palette.nix"
                echo "      $(sed 's/^[[:space:]]*//' <<<"$line")"
                fail=1
            fi
        done
    done < <(grep -niE '#{1,2}[0-9A-F]{6}|rgba?\([0-9A-F]{6,8}\)' "$file" || true)
done

if [ "$fail" -eq 0 ]; then
    echo "theme-lint: clean — ${#files[@]} files, every colour is Kanagawa Wave."
fi
exit "$fail"
