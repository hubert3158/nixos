#!/usr/bin/env bash
# Claude Code statusline: caveman badge, then claude-powerline.
# Symlinked to ~/.claude/statusline-command.sh, which settings.json runs.
# claude-powerline reads the session JSON from stdin, so leave stdin unread here.

FLAG="${CLAUDE_CONFIG_DIR:-$HOME/.claude}/.caveman-active"
if [ ! -L "$FLAG" ] && [ -f "$FLAG" ]; then
  MODE=$(head -c 64 "$FLAG" 2>/dev/null | tr -d '\n\r' | tr '[:upper:]' '[:lower:]')
  MODE=$(printf '%s' "$MODE" | tr -cd 'a-z0-9-')
  case "$MODE" in
    off | lite | full | ultra | wenyan-lite | wenyan | wenyan-full | wenyan-ultra | commit | review | compress)
      if [ "$MODE" = "full" ]; then
        printf '\033[38;5;172m[CAVEMAN]\033[0m'
      else
        printf '\033[38;5;172m[CAVEMAN:%s]\033[0m' "$(printf '%s' "$MODE" | tr '[:lower:]' '[:upper:]')"
      fi
      SAVINGS_FILE="${CLAUDE_CONFIG_DIR:-$HOME/.claude}/.caveman-statusline-suffix"
      if [ "${CAVEMAN_STATUSLINE_SAVINGS:-1}" != "0" ] && [ -f "$SAVINGS_FILE" ] && [ ! -L "$SAVINGS_FILE" ]; then
        SAVINGS=$(head -c 64 "$SAVINGS_FILE" 2>/dev/null | tr -d '\000-\037')
        [ -n "$SAVINGS" ] && printf ' \033[38;5;172m%s\033[0m' "$SAVINGS"
      fi
      printf ' '
      ;;
  esac
fi

exec claude-powerline
