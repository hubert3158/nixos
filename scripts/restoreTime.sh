#!/usr/bin/env bash
set -euo pipefail

if [[ $EUID -ne 0 ]]; then
    echo "Run as root: sudo $0"
    exit 1
fi

echo "Re-enabling NTP…"
systemctl start systemd-timesyncd.service || true
systemctl restart systemd-timesyncd.service || true

echo "Waiting for sync…"
sleep 2

echo
echo "Status:"
timedatectl || true

echo
echo "Current time (UTC):"
date -u
