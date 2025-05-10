#    _               _
#   | |__   __ _ ___| |__  _ __ ___
#   | '_ \ / _` / __| '_ \| '__/ __|
#  _| |_) | (_| \__ \ | | | | | (__
# (_)_.__/ \__,_|___/_| |_|_|  \___|
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return
PS1='[\u@\h \W]\$ '

# -----------------------------------------------------
# LOAD CUSTOM .bashrc_custom if exists
# -----------------------------------------------------
if [ -f ~/.bashrc_custom ]; then
  source ~/.bashrc_custom
fi

if [ "$SHLVL" -eq 1 ]; then
  exec zsh -l
else
  exec zsh
fi

host() {
  distrobox-host-exec env NO_DISTROBOX_AUTOENTER=1 "$@"
}

reset-container() {
  host systemctl --user start reset-hyprome.service
}

if [ -z "$container" ] && [ -z "$NO_DISTROBOX_AUTOENTER" ] && [ -n "$PS1" ]; then
  CONTAINER_NAME="hyprome-dev-distrobox-quadlet"

  # Check if container is running on the host
  if host podman container exists "$CONTAINER_NAME" &&
    host podman inspect -f '{{.State.Running}}' "$CONTAINER_NAME" | grep -q true; then

    exec distrobox enter "$CONTAINER_NAME"
  else
    echo "⚠️ Container '$CONTAINER_NAME' is not ready yet."
    echo "💡 You can try again later with: distrobox enter $CONTAINER_NAME"
  fi
fi
