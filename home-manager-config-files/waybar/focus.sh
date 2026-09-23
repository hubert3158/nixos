#!/usr/bin/env bash
# ekagra (एकाग्र, "one-pointed") — focus timer for waybar's custom/focus.
#
#   focus.sh           daemon: waybar's exec; emits one JSON line per change
#   focus.sh toggle    start a session (FOCUS_MINUTES, default 25) or stop it
#   focus.sh add       +5 minutes (starts a 5-minute session when idle)
#   focus.sh stop      end the session
#
# The daemon blocks on a FIFO read. Idle, that read has no timeout — zero
# wakeups, zero forks, per the no-idle-cost rule in docs/THEME.md. Running, it
# wakes exactly on each minute boundary to redraw, then goes back to sleep.

fifo="${XDG_RUNTIME_DIR:-/tmp}/waybar-focus.fifo"
LEN=${FOCUS_MINUTES:-25}

case "${1:-}" in
    toggle | add | stop)
        # timeout: if the daemon isn't reading, a plain write would hang forever
        [ -p "$fifo" ] && timeout 1 sh -c 'printf "%s\n" "$1" >"$2"' _ "$1" "$fifo"
        exit 0
        ;;
esac

[ -p "$fifo" ] || { rm -f "$fifo"; mkfifo "$fifo"; }
# read-write open: never blocks on open, and never sees EOF between writers
exec 3<>"$fifo"

deva() { # Latin digits → Devanagari numerals
    local s=$1 d
    local -a map=(० १ २ ३ ४ ५ ६ ७ ८ ९)
    for d in 0 1 2 3 4 5 6 7 8 9; do s=${s//$d/${map[$d]}}; done
    printf '%s' "$s"
}

emit() { # text class tooltip
    jq -cn --arg t "$1" --arg c "$2" --arg tt "$3" '{text: $t, class: $c, tooltip: $tt}'
}

end=0
started=0
while :; do
    timeout=""
    if ((end > 0)); then
        left=$((end - EPOCHSECONDS))
        if ((left <= 0)); then
            mins=$(((end - started) / 60))
            end=0
            notify-send -a ekagra -u normal "एकाग्र  ekagra" \
                "$mins minutes of one thing. Stand up, look far away." 2>/dev/null
        else
            mins=$(((left + 59) / 60))
            timeout=$((left - (mins - 1) * 60))
            class=running
            ((mins <= 5)) && class=ending
            emit "󰔟 $(deva "$mins")" "$class" \
                "ekagra — $mins min left (until $(date -d "@$end" +%H:%M))
click: stop · scroll up: +5 min"
        fi
    fi
    if ((end == 0)); then
        emit "󰔛" idle "ekagra — focus timer
click: start $LEN min · scroll up: 5 min"
    fi

    cmd=""
    if [ -n "$timeout" ]; then
        read -r -t "$timeout" cmd <&3
    else
        read -r cmd <&3
    fi

    case "$cmd" in
        toggle)
            if ((end > 0)); then
                end=0
            else
                started=$EPOCHSECONDS
                end=$((started + LEN * 60))
            fi
            ;;
        add)
            if ((end > 0)); then
                end=$((end + 300))
            else
                started=$EPOCHSECONDS
                end=$((started + 300))
            fi
            ;;
        stop) end=0 ;;
    esac
done
