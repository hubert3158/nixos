#!/usr/bin/env bash
# Audio visualizer for waybar — renders cava's raw ascii as block glyphs.
# Silently absent until cava is installed; sleep_timer in cava.conf pauses
# output when nothing is playing.

command -v cava >/dev/null || exit 0

exec cava -p /home/hubert/nixos/home-manager-config-files/waybar/cava.conf |
    sed -u 's/;//g; s/0/▁/g; s/1/▂/g; s/2/▃/g; s/3/▄/g; s/4/▅/g; s/5/▆/g; s/6/▇/g; s/7/█/g'
