#!/usr/bin/env bash
set -euo pipefail

# Hardcoded fake date/time
FAKE_DATE="2025-11-02 6:00:00"

if [[ $EUID -ne 0 ]]; then
    echo "Run this script as root: sudo $0"
    exit 1
fi

echo "Stopping systemd-timesyncd (NTP)…"
systemctl stop systemd-timesyncd.service || {
    echo "Warning: systemd-timesyncd may not be running."
}

echo "Setting system date/time to: $FAKE_DATE"
date -s "$FAKE_DATE"

echo
echo "Current system time:"
date

echo
echo "timedatectl status:"
timedatectl || true

echo
echo "Done. System is now using fake time ($FAKE_DATE)."
echo "Remember to run restore-time.sh afterward."
