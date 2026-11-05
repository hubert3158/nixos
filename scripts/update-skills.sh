#!/usr/bin/env bash
# Update Claude Code skills and plugins. None of these live in the repo, so run
# this on each machine. Called by update-everything.sh, also safe to run alone.
#
#   1. skills CLI — ~/.agents/skills, sources in ~/.local/state/skills
#   2. plugins    — marketplaces, then every installed plugin
#   3. git clones — fast-forward only, local work is never overwritten
#
# Not covered: graphify (CLI comes from uv-tools.nix on rebuild) and hand-copied
# skills with no tracked source.
#
# Plugin updates deliberately omit -y: a plugin whose install command changed
# stops and shows the new command for confirmation.
#
# One failed source doesn't stop the others; exits non-zero if any failed.
# Restart Claude Code afterwards.

set -uo pipefail

failed=()

run() {
  local label="$1"
  shift
  "$@" || {
    echo "    FAILED: $label"
    failed+=("$label")
  }
}

echo "==> skills CLI"
run "skills CLI" npx --yes skills update -g -y

echo "==> plugin marketplaces"
run "plugin marketplaces" claude plugin marketplace update

echo "==> plugins"
# A for loop, not xargs: plugin update needs stdin to ask for confirmation.
# @synced plugins come from the claude.ai account and can't be updated here.
plugins=$(claude plugin list | awk '/❯/ && $2 !~ /@synced$/ { print $2 }')
for plugin in $plugins; do
  echo "--> $plugin"
  run "plugin $plugin" claude plugin update "$plugin"
done

echo "==> git clones"
for dir in "$HOME/.claude/skills/prompt-master" "$HOME/IdeaProjects/motionmaxxing"; do
  if [ -d "$dir/.git" ]; then
    echo "--> $dir"
    run "git pull $dir" git -C "$dir" pull --ff-only
  else
    echo "--> $dir not on this machine, skipping"
  fi
done

if [ "${#failed[@]}" -gt 0 ]; then
  echo "Failed: ${failed[*]}"
  exit 1
fi

echo "Skills updated. Restart Claude Code to load them."
