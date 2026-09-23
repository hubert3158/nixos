#!/usr/bin/env bash
# Screen recording toggle — wf-recorder, Himal-styled slurp selection.
#
#   record.sh region   pick a region and start (or stop, if already recording)
#   record.sh screen   record the focused monitor (or stop)
#   record.sh stop     stop
#   record.sh status   JSON for waybar's custom/record (empty = hidden)
#
# Bound to SUPER+CTRL+N (region) / SUPER+CTRL+SHIFT+N (screen) in
# dotfiles/hypr/hyprland.lua; also the camera entry in waybar's utility drawer.
# Waybar is told about every change via RTMIN+9, so its module never polls.

dir="${XDG_VIDEOS_DIR:-$HOME/Videos}/Recordings"
signal_bar() { pkill -RTMIN+9 -x waybar 2>/dev/null || true; }

recording() { pgrep -x wf-recorder >/dev/null; }

stop() {
    pkill -INT -x wf-recorder
    # wait for the muxer to finalise the file before announcing it
    for _ in $(seq 20); do recording || break; sleep 0.1; done
    signal_bar
    local last
    last=$(ls -t "$dir"/*.mp4 2>/dev/null | head -1)
    notify-send -a record "󰯜  recording saved" "${last/#$HOME/\~}" 2>/dev/null
}

start() { # extra wf-recorder args…
    command -v wf-recorder >/dev/null || {
        notify-send -a record "wf-recorder missing" "rebuild to install it" 2>/dev/null
        exit 1
    }
    mkdir -p "$dir"
    local file="$dir/$(date +%F_%H-%M-%S).mp4"
    # setsid: detach from waybar/hyprland so a bar restart can't kill the take
    setsid -f sh -c 'wf-recorder "$@" -f "$0" >/dev/null 2>&1; pkill -RTMIN+9 -x waybar' "$file" "$@"
    sleep 0.3
    signal_bar
}

case "${1:-region}" in
    status)
        if recording; then
            printf '{"text":"󰑋 rec","class":"recording","tooltip":"recording — click to stop"}\n'
        else
            printf '{"text":""}\n'
        fi
        ;;
    stop) recording && stop ;;
    screen)
        if recording; then stop; exit; fi
        mon=$(hyprctl activeworkspace -j | jq -r '.monitor')
        start -o "$mon"
        ;;
    region | *)
        if recording; then stop; exit; fi
        # ink wash over the screen, crystalBlue rule around the selection
        geom=$(slurp -d -b 16161d99 -c 7e9cd8ff -s 7e9cd822 -w 2) || exit 0
        start -g "$geom"
        ;;
esac
