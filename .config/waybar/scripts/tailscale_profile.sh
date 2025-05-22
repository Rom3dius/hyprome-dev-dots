#!/bin/bash

# Get current Tailscale status
STATUS_JSON=$(tailscale status --json 2>/dev/null)
BACKEND_STATE=$(jq -r '.BackendState // empty' <<<"$STATUS_JSON")
if [[ "$BACKEND_STATE" != "Running" ]]; then
  CURRENT_TAILNET="disconnected"
else
  CURRENT_TAILNET=$(jq -r '.CurrentTailnet.Name // empty' <<<"$STATUS_JSON")
fi

# Build the list of available tailnets dynamically
TAILNETS=($(
  tailscale switch --list | awk 'NR > 1 {print $2}'
  echo disconnected
))

# Get index of current tailnet
get_index() {
  for i in "${!TAILNETS[@]}"; do
    if [[ "${TAILNETS[$i]}" == "$1" ]]; then
      echo "$i"
      return
    fi
  done
  echo "-1"
}

# Handle --next click event
if [[ "$1" == "--next" ]]; then
  CURRENT_INDEX=$(get_index "$CURRENT_TAILNET")
  NEXT_INDEX=$(((CURRENT_INDEX + 1) % ${#TAILNETS[@]}))
  NEXT="${TAILNETS[$NEXT_INDEX]}"
  echo $NEXT

  if [[ "$NEXT" == "disconnected" ]]; then
    tailscale down >/dev/null
  else
    tailscale switch "$NEXT" >/dev/null
    tailscale up >/dev/null
  fi
  echo "{\"text\": \"󰖂  $NEXT\", \"tooltip\": \"Connected to tailnet: $NEXT\"}"
  exit 0
fi

# Output for Waybar
if [[ "$BACKEND_STATE" != "Running" ]]; then
  echo '{"text": "󰖂  Disconnected", "tooltip": "Tailscale is not connected."}'
else
  echo "{\"text\": \"󰖂  $CURRENT_TAILNET\", \"tooltip\": \"Connected to tailnet: $CURRENT_TAILNET\"}"
fi
