#!/usr/bin/env bash
# Keybinding cheat sheet — SUPER+/ and the keyboard entry in waybar's utility drawer.
#
# Reads the live bind table from Hyprland, so it can never drift from
# hyprland.lua: every bind registered with a `description` shows up, anything
# without one stays out (mouse drags, per-key workspace spam, media keys).
# Picking a line does nothing but close the sheet — it's a reference card.

hyprctl binds -j | jq -r '
    def mods:
        [ (if ((.modmask / 64 | floor) % 2) == 1 then "SUPER" else empty end),
          (if ((.modmask /  4 | floor) % 2) == 1 then "CTRL"  else empty end),
          (if ((.modmask /  8 | floor) % 2) == 1 then "ALT"   else empty end),
          (if ( .modmask             % 2) == 1 then "SHIFT" else empty end) ];
    .[]
    | select(.has_description and .submap == "")
    | ((mods + [.key]) | join(" + ")) as $combo
    | "\($combo)\t\(.description)"
' | column -t -s $'\t' |
    fuzzel --dmenu --prompt '󰥻  ' --placeholder 'keybindings' \
        --width 72 --lines 22 >/dev/null
