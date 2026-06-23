#!/usr/bin/env bash

zellij_sessions=$(zellij list-sessions 2>/dev/null | sed 's/\x1b\[[0-9;]*m//g' | awk '{print $1}' | grep -v "^$")

if [ -z "$zellij_sessions" ]; then
  fuzzel -d --prompt-only "zellij: no sessions available"
  exit 1
fi

session=$(echo "$zellij_sessions" | fuzzel -d --placeholder "Select zellij session...")

if [ -n "$session" ]; then
  kitty -o allow_remote_control=yes zellij attach "$session"
fi
