#!/usr/bin/env bash
# Power menu for the waybar ⏻ button, rendered with fuzzel in dmenu mode.

chosen=$(printf '󰌾  Lock\n󰍃  Logout\n󰒲  Suspend\n󰜉  Reboot\n󰐥  Shutdown' | fuzzel --dmenu --lines 5 --width 22 --prompt '⏻ ')

case "$chosen" in
    *Lock*)     hyprlock ;;
    *Logout*)   hyprctl dispatch exit ;;
    *Suspend*)  systemctl suspend ;;
    *Reboot*)   systemctl reboot ;;
    *Shutdown*) systemctl poweroff ;;
esac
