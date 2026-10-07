#!/usr/bin/env bash
session=$1
[ -n "$session" ] || exit 1
title="zellij-session-$session"

id=$(fenstrctl --json get tree | jq -r --arg t "$title" '.. | objects | select(.title? == $t) | .id' | head -n1)
if [ -n "$id" ]; then
  exec fenstrctl focus window "$id"
fi
exec ghostty --title="$title" -e zellij attach --create "$session"
