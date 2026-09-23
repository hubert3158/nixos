#!/usr/bin/env bash
# Weather for waybar via wttr.in — outputs JSON {text, tooltip, class}.
# Hides itself (empty text) when offline.
# Icon is mapped from the condition text: wttr's %c emits color emoji,
# which breaks the bar's nf-md-glyphs-only rule (docs/THEME.md). The same goes
# for the moon (%m): its emoji phase is translated to the nf-md moon set.
#
# After sunset the sky glyphs switch to their night forms and the pill takes
# the `night` class (style.css cools it from carpYellow to springViolet), so
# the centre island quietly follows the actual light outside.

data=$(curl -sf --max-time 8 'wttr.in/?format=%t|%C|%f|%w|%h|%l|%m|%S|%s|%p')

if [ -z "$data" ]; then
    printf '{"text": ""}\n'
    exit 0
fi

IFS='|' read -r temp cond feels wind humidity loc moon sunrise sunset precip <<< "$data"

# wttr prefixes temps with '+'
temp=${temp#+}
feels=${feels#+}

# day or night, by the location's own sunrise/sunset (HH:MM:SS compares as text)
now=$(date +%H:%M:%S)
night=0
[[ -n $sunrise && -n $sunset ]] && [[ $now < $sunrise || $now > $sunset ]] && night=1

# condition text → nf-md glyph
case "${cond,,}" in
    *thunder*)                        icon="󰖓" ;;
    *snow*|*sleet*|*blizzard*|*ice*)  icon="󰖘" ;;
    *rain*|*drizzle*|*shower*)        icon="󰖖" ;;
    *fog*|*mist*|*haze*)              icon="󰖑" ;;
    *overcast*)                       icon="󰖐" ;;
    *partly*)                         ((night)) && icon="󰼱" || icon="󰖕" ;;
    *cloud*)                          icon="󰖐" ;;
    *clear*|*sunny*)                  ((night)) && icon="󰖔" || icon="󰖙" ;;
    *)                                icon="󰖕" ;;
esac

# emoji moon phase → nf-md moon glyph + name
case "$moon" in
    🌑) mglyph="󰽤";              mname="new moon" ;;
    🌒) mglyph="󰽧";  mname="waxing crescent" ;;
    🌓) mglyph="󰽡";    mname="first quarter" ;;
    🌔) mglyph="󰽨";   mname="waxing gibbous" ;;
    🌕) mglyph="󰽢";             mname="full moon" ;;
    🌖) mglyph="󰽦";   mname="waning gibbous" ;;
    🌗) mglyph="󰽣";     mname="last quarter" ;;
    🌘) mglyph="󰽥";  mname="waning crescent" ;;
    *)  mglyph="";                        mname="" ;;
esac

class=day
((night)) && class=night

tooltip="$loc
$cond, $temp (feels $feels)
wind $wind · humidity $humidity · rain $precip
󰖜 ${sunrise%:*}   󰖛 ${sunset%:*}"
[ -n "$mname" ] && tooltip+="
$mglyph $mname"

jq -cn --arg text "$icon $temp" --arg tooltip "$tooltip" --arg class "$class" \
       '{text: $text, tooltip: $tooltip, class: $class}'
