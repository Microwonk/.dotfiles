#!/usr/bin/env bash

if command -v hyprctl &>/dev/null && hyprctl monitors &>/dev/null 2>&1; then
  echo "hyprland"
elif command -v swaymsg &>/dev/null; then
  echo "sway"
else
  echo "unknown"
fi
