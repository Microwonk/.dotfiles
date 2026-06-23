#!/usr/bin/env bash
set -euo pipefail

OUT="$HOME/Pictures/Screenshots/$(date '+%Y-%m-%d_%H-%M-%S').png"
mkdir -p "$HOME/Pictures/Screenshots"

mode="${1:-}"

copy_and_save() {
  tee "$OUT" | wl-copy
}

case "$mode" in
  selection)
    GEOM="$(slurp)"
    grim -g "$GEOM" - | copy_and_save
    ;;
  fullscreen)
    grim - | copy_and_save
    ;;
  active)
    if command -v hyprctl >/dev/null 2>&1; then
      geom_str="$(hyprctl -j activewindow 2>/dev/null \
        | jq -r '"\(.at[0]),\(.at[1]) \(.size[0])x\(.size[1])"')"
      grim -g "$geom_str" - | copy_and_save
    else
      geom_str="$(swaymsg -t get_tree 2>/dev/null \
        | jq -r '.. | select(.focused?) | .rect | "\(.x),\(.y) \(.width)x\(.height)"')"
      grim -g "$geom_str" - | copy_and_save
    fi
    ;;
  *)
    echo "Usage: cshot {selection|fullscreen|active}" >&2
    exit 1
    ;;
esac
