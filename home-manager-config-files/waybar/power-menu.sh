#!/usr/bin/env bash
# Power menu for the waybar ⏻ button — wlogout ink cards (Ink & Wave).
# Falls back to a fuzzel dmenu if wlogout isn't installed yet.

if command -v wlogout >/dev/null 2>&1; then
    exec wlogout -b 3 --protocol layer-shell
fi

chosen=$(printf '󰌾  Lock\n󰍃  Logout\n󰒲  Suspend\n󰜉  Reboot\n󰐥  Shutdown' | fuzzel --dmenu --lines 5 --width 22 --prompt '⏻ ')

case "$chosen" in
    *Lock*)     hyprlock ;;
    *Logout*)   hyprctl dispatch exit ;;
    *Suspend*)  systemctl suspend ;;
    *Reboot*)   systemctl reboot ;;
    *Shutdown*) systemctl poweroff ;;
esac
