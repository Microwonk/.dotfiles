#!/bin/sh

if [ -n "$HYPRLAND_INSTANCE_SIGNATURE" ]; then
  waybar -c ~/.config/waybar/hypr-config.jsonc
else
  waybar -c ~/.config/waybar/sway-config.jsonc
fi
