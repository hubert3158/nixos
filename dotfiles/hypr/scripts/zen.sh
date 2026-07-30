#!/usr/bin/env bash
# dhyan — dhyan mode. One keystroke between "workstation" and "reading room".
# (dhyan and zen are the same Sanskrit word, dhyana, taking two routes out.)
#
# On:  the bar folds away, the gaps open into wide paper margins, the border
#      thins to a hairline. Nothing is killed and nothing is restarted, so the
#      toggle is instant and costs nothing while it sits there.
# Off: every value is written back explicitly (hyprctl has no "unset", and a
#      reload would drop other live keyword tweaks).
#
# Bound to SUPER+Z in dotfiles/hypr/hyprland.conf.
# The defaults below MUST match the general/decoration blocks in that file.

set -euo pipefail

state="${XDG_RUNTIME_DIR:-/tmp}/hypr-zen"

note() {
    command -v notify-send >/dev/null 2>&1 && notify-send -a hyprland "$1" "$2"
    return 0
}

if [ -f "$state" ]; then
    rm -f "$state"
    hyprctl --batch "\
        keyword general:gaps_in 6 ; \
        keyword general:gaps_out 6,14,14,14 ; \
        keyword general:border_size 3 ; \
        keyword decoration:rounding 10 ; \
        keyword decoration:dim_strength 0.12" >/dev/null
    pkill -SIGUSR1 waybar || true
    note "ध्यान  dhyan off" "back to the grid"
else
    : >"$state"
    hyprctl --batch "\
        keyword general:gaps_in 14 ; \
        keyword general:gaps_out 40,240,60,240 ; \
        keyword general:border_size 1 ; \
        keyword decoration:rounding 16 ; \
        keyword decoration:dim_strength 0.3" >/dev/null
    pkill -SIGUSR1 waybar || true
    note "ध्यान  dhyan on" "one thing at a time"
fi
