#!/usr/bin/env bash
# Audio visualizer for waybar — renders cava's raw ascii as block glyphs.
# Silently absent until cava is installed; sleep_timer in cava.conf pauses
# output when nothing is playing.

command -v cava >/dev/null || exit 0

# Waybar may start before the pipewire session is up; cava then prints a bare
# terminal-title escape (\e]0;cava\a) to stdout and exits, which would stick in
# the module as tofu glyphs. Strip OSC sequences, clear the module on exit, and
# retry until pipewire is reachable.
while :; do
    cava -p /home/hubert/nixos/home-manager-config-files/waybar/cava.conf 2>/dev/null |
        sed -u 's/\x1b][^\x07]*\x07//g; s/;//g; s/0/▁/g; s/1/▂/g; s/2/▃/g; s/3/▄/g; s/4/▅/g; s/5/▆/g; s/6/▇/g; s/7/█/g'
    echo ""
    sleep 2
done
