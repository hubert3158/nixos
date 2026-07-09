#!/usr/bin/env bash
# Weather for waybar via wttr.in — outputs JSON {text, tooltip}.
# Hides itself (empty text) when offline.

data=$(curl -sf --max-time 8 'wttr.in/?format=%c|%t|%C|%f|%w|%h|%l')

if [ -z "$data" ]; then
    printf '{"text": ""}\n'
    exit 0
fi

IFS='|' read -r icon temp cond feels wind humidity loc <<< "$data"

# wttr pads emoji with a trailing space and prefixes temps with '+'
icon=${icon% }
temp=${temp#+}
feels=${feels#+}

jq -cn --arg text "$icon $temp" \
       --arg tooltip "$loc
$cond, $temp (feels $feels)
wind $wind · humidity $humidity" \
       '{text: $text, tooltip: $tooltip}'
