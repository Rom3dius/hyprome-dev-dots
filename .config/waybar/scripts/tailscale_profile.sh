#!/bin/bash

# Get the full Tailscale status JSON
STATUS_JSON=$(tailscale status --json 2>/dev/null)

# Extract values
BACKEND_STATE=$(jq -r '.BackendState // empty' <<<"$STATUS_JSON")
TAILNET_NAME=$(jq -r '.CurrentTailnet.Name // empty' <<<"$STATUS_JSON")

# Determine connection state
if [[ "$BACKEND_STATE" != "Running" ]]; then
  echo '{"text": "󰖂  Disconnected", "tooltip": "Tailscale is not connected."}'
else
  echo "{\"text\": \"󰖂  $TAILNET_NAME\", \"tooltip\": \"Connected to tailnet: $TAILNET_NAME\"}"
fi
