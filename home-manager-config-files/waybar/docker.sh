#!/usr/bin/env bash
# Running docker container count for waybar — outputs JSON {text, tooltip, class}.
# Class "hidden" collapses the module via CSS when nothing is running.

names=$(docker ps --format '{{.Names}}' 2>/dev/null)

if [ -z "$names" ]; then
    printf '{"text": "", "class": "hidden"}\n'
    exit 0
fi

count=$(wc -l <<< "$names")

jq -cn --arg text "󰡨 $count" --arg tooltip "$names" \
       '{text: $text, tooltip: $tooltip, class: "docker"}'
