#!/usr/bin/env bash
# Audio visualizer for waybar — renders cava's raw ascii as block glyphs.
# Silently absent until cava is installed. On silence, flat bars linger for
# GRACE seconds before the module clears (cava.conf's sleep_timer must be
# larger than GRACE, or cava stops emitting frames before we can hide).

command -v cava >/dev/null || exit 0

GRACE=5

# Waybar may start before the pipewire session is up; cava then prints a bare
# terminal-title escape (\e]0;cava\a) to stdout and exits, which would stick in
# the module as tofu glyphs. Strip OSC sequences, clear the module on exit, and
# retry until pipewire is reachable.
while :; do
    cava -p /home/hubert/nixos/home-manager-config-files/waybar/cava.conf 2>/dev/null |
        sed -u 's/\x1b][^\x07]*\x07//g; s/;//g' |
        while IFS= read -r frame; do
            if [[ $frame == *[1-7]* ]]; then
                last_active=$EPOCHSECONDS
            elif (( EPOCHSECONDS - ${last_active:-0} >= GRACE )); then
                echo ""
                continue
            fi
            frame=${frame//0/▁}; frame=${frame//1/▂}; frame=${frame//2/▃}
            frame=${frame//3/▄}; frame=${frame//4/▅}; frame=${frame//5/▆}
            frame=${frame//6/▇}; frame=${frame//7/█}
            printf '%s\n' "$frame"
        done
    echo ""
    sleep 2
done
