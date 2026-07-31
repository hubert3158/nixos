#!/usr/bin/env bash
# dhyan — dhyan mode. One keystroke between "workstation" and "reading room".
# (dhyan and zen are the same Sanskrit word, dhyana, taking two routes out.)
#
# On:  the bar folds away, the gaps open into wide paper margins, the border
#      thins to a hairline. Nothing is killed and nothing is restarted, so the
#      toggle is instant and costs nothing while it sits there.
# Off: every value is written back explicitly (there is no "unset", and a
#      reload would drop other live tweaks).
#
# Bound to SUPER+Z in dotfiles/hypr/hyprland.lua.
# The defaults below MUST match the general/decoration blocks in that file.
#
# `hyprctl keyword` only works with the legacy hyprlang parser and returns
# "keyword can't work with non-legacy parsers. Use eval." under the Lua config
# manager, so live tweaks go through `hyprctl eval` + hl.config() instead.
# gaps_out is a CSS gap: a table of top/right/bottom/left.

set -euo pipefail

state="${XDG_RUNTIME_DIR:-/tmp}/hypr-zen"

note() {
    command -v notify-send >/dev/null 2>&1 && notify-send -a hyprland "$1" "$2"
    return 0
}

apply() {
    # $1 gaps_in, $2..$5 gaps_out t/r/b/l, $6 border_size, $7 rounding, $8 dim_strength
    hyprctl eval "hl.config({
        general = {
            gaps_in = $1,
            gaps_out = { top = $2, right = $3, bottom = $4, left = $5 },
            border_size = $6,
        },
        decoration = {
            rounding = $7,
            dim_strength = $8,
        },
    })" >/dev/null
}

if [ -f "$state" ]; then
    rm -f "$state"
    apply 6 6 14 14 14 3 10 0.12
    pkill -SIGUSR1 waybar || true
    note "ध्यान  dhyan off" "back to the grid"
else
    : >"$state"
    apply 14 40 240 60 240 1 16 0.3
    pkill -SIGUSR1 waybar || true
    note "ध्यान  dhyan on" "one thing at a time"
fi
