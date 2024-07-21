#!/run/current-system/sw/bin/sh

CONFIG_FILES="$HOME/.config/waybar/config $HOME/.config/waybar/style.css"
WAYBAR_PIDS=$(pgrep waybar)

if [ -z "$WAYBAR_PIDS" ]; then
  echo "Waybar is not running."
  exit 1
fi

echo "Monitoring files: $CONFIG_FILES"
echo "Waybar PIDs: $WAYBAR_PIDS"

inotifywait -m -e close_write --format '%w%f' $CONFIG_FILES | while read MODIFIED
do
  echo "File $MODIFIED modified. Reloading Waybar..."
  for pid in $WAYBAR_PIDS; do
    echo "Sending SIGUSR2 to PID $pid"
    kill -SIGUSR2 $pid
  done
done

