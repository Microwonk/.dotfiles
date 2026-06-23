#!/usr/bin/env bash

zellij_sessions=$(zellij list-sessions 2>/dev/null | sed 's/\x1b\[[0-9;]*m//g' | awk '{print $1}' | grep -v "^$")

if [ -z "$zellij_sessions" ]; then
  fuzzel -d --prompt-only "zellij: no sessions available"
  exit 1
fi

session=$(echo "$zellij_sessions" | fuzzel -d --placeholder "Select zellij session...")

[ -z "$session" ] && exit 0

compositor=$(~/.config/scripts/get-compositor.sh)

find_and_focus_window() {
  local title="zellij-session-$1"

  if [ "$compositor" = "hyprland" ]; then
    match=$(hyprctl clients -j | jq -r --arg t "$title" '
      .[] | select(.title == $t) | .address
    ' | head -n1)
    if [ -n "$match" ]; then
      hyprctl dispatch focuswindow "address:$match"
      return 0
    fi

  elif [ "$compositor" = "sway" ]; then
    match=$(swaymsg -t get_tree | jq -r --arg t "$title" '
      .. | objects |
      select(
        (.app_id == "kitty" or .window_properties.class == "kitty") and
        (.name == $t)
      ) | .id
    ' | head -n1)
    if [ -n "$match" ]; then
      swaymsg "[con_id=$match] focus"
      return 0
    fi
  fi

  return 1
}

if find_and_focus_window "$session"; then
  exit 0
fi

kitty --title "zellij-session-$session" -o allow_remote_control=yes zellij attach "$session"
