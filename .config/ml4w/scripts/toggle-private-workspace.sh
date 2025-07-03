#!/bin/bash

PRIVATE_WS="private"
STATE_FILE="/tmp/hypr-private-overlay"
CURRENT_MONITOR=$(hyprctl activeworkspace -j | jq -r '.monitor')
CURRENT_WS=$(hyprctl activeworkspace -j | jq -r '.name')

# If we are currently showing privatebrowsing, toggle back
if [ "$CURRENT_WS" = "$PRIVATE_WS" ]; then
  if [ -f "$STATE_FILE" ]; then
    ORIGINAL_WS=$(cat "$STATE_FILE")
    hyprctl dispatch workspace "$ORIGINAL_WS"
  fi
  exit 0
fi

# Save current workspace
echo "$CURRENT_WS" >"$STATE_FILE"

# Move privatebrowsing workspace to current monitor and switch to it
hyprctl dispatch moveworkspacetomonitor name:$PRIVATE_WS "$CURRENT_MONITOR"
hyprctl dispatch workspace name:$PRIVATE_WS
