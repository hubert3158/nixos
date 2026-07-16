#!/usr/bin/env bash
# Weather for waybar via wttr.in — outputs JSON {text, tooltip}.
# Hides itself (empty text) when offline.
# Icon is mapped from the condition text: wttr's %c emits color emoji,
# which breaks the bar's nf-md-glyphs-only rule (docs/THEME.md).

data=$(curl -sf --max-time 8 'wttr.in/?format=%t|%C|%f|%w|%h|%l')

if [ -z "$data" ]; then
    printf '{"text": ""}\n'
    exit 0
fi

IFS='|' read -r temp cond feels wind humidity loc <<< "$data"

# wttr prefixes temps with '+'
temp=${temp#+}
feels=${feels#+}

# condition text → nf-md glyph
case "${cond,,}" in
    *thunder*)                        icon="󰖓" ;;
    *snow*|*sleet*|*blizzard*|*ice*)  icon="󰖘" ;;
    *rain*|*drizzle*|*shower*)        icon="󰖗" ;;
    *fog*|*mist*|*haze*)              icon="󰖑" ;;
    *overcast*)                       icon="󰖐" ;;
    *cloud*)                          icon="󰖕" ;;
    *clear*|*sunny*)                  icon="󰖙" ;;
    *)                                icon="󰖕" ;;
esac

jq -cn --arg text "$icon $temp" \
       --arg tooltip "$loc
$cond, $temp (feels $feels)
wind $wind · humidity $humidity" \
       '{text: $text, tooltip: $tooltip}'
