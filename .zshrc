#                   .__                   
#    ________  _____|  |_________   ____  
#    \___   / /  ___/  |  \_  __ \_/ ___\ 
#     /    /  \___ \|   Y  \  | \/\  \___ 
# /\ /_____ \/____  >___|  /__|    \___  >
# \/       \/     \/     \/            \/ 
# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

export EDITOR="nvim"
export TERM="xterm-256color"

# before anything else, yadm decrypt
decrypt_yadm_if_needed() {
  local enc_file="$HOME/.local/share/yadm/archive"
  local hash_file="$HOME/.cache/yadm-decrypt.hash"

  mkdir -p ~/.cache

  # If no hash exists, or the file has changed
  if [[ ! -f "$hash_file" ]] || ! cmp -s <(sha256sum "$enc_file" | cut -d ' ' -f1) "$hash_file"; then
    echo "[yadm] Encrypted files changed. Decrypting..."
    yadm decrypt && sha256sum "$enc_file" | cut -d ' ' -f1 > "$hash_file"
  fi
}

if [ -z "$container" ]; then
  decrypt_yadm_if_needed
fi

# brew
if [[ -z ${BREW_LOADED-} ]]; then                # run only once per shell
  HB="/home/linuxbrew/.linuxbrew/bin/brew"       # canonical Linuxbrew path
  [[ -x $HB ]] && eval "$($HB shellenv 2>/dev/null)" && export BREW_LOADED=1
fi

# setup zsh and zsh plugins
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="agnoster"

plugins=(
  git
  dnf
  kitty
  extract
  podman
  ssh-agent
)

source "$ZSH/oh-my-zsh.sh"

# ────────────────────────────────── fzf key‑bindings ─────────────────────────
source <(fzf --zsh)

# ────────────────────────────────── history / PATH ────────────────────────────
HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
setopt appendhistory

path+=("$HOME/.local/bin")

# ───────────────────────────── pretty ls via lsd ──────────────────────────────
alias ls='lsd'
alias l='ls -l'
alias la='ls -a'
alias lla='ls -la'
alias lt='ls --tree'

# archives
# Archives
function extract {
  if [ -z "$1" ]; then
    echo "Usage: extract <path/file_name>.<zip|rar|bz2|gz|tar|tbz2|tgz|Z|7z|xz|ex|tar.bz2|tar.gz|tar.xz>"
  else
    if [ -f $1 ]; then
      case $1 in
        *.tar.bz2)   tar xvjf $1    ;;
        *.tar.gz)    tar xvzf $1    ;;
        *.tar.xz)    tar xvJf $1    ;;
        *.lzma)      unlzma $1      ;;
        *.bz2)       bunzip2 $1     ;;
        *.rar)       unrar x -ad $1 ;;
        *.gz)        gunzip $1      ;;
        *.tar)       tar xvf $1     ;;
        *.tbz2)      tar xvjf $1    ;;
        *.tgz)       tar xvzf $1    ;;
        *.zip)       unzip $1       ;;
        *.Z)         uncompress $1  ;;
        *.7z)        7z x $1        ;;
        *.xz)        unxz $1        ;;
        *.exe)       cabextract $1  ;;
        *)           echo "extract: '$1' - unknown archive method" ;;
      esac
    else
      echo "$1 - file does not exist"
    fi
  fi
}
alias extr='extract '
function extract_and_remove {
  extract $1
  rm -f $1
}
alias extrr='extract_and_remove '

# Custom aliases
alias fperm='stat -c "%a %n"'
alias update-dots='yadm clone -f https://github.com/Rom3dius/hyprome-dev-dots && yadm checkout "/home/romedius"'

# ─────────────────────────── ~/.extras overrides (SAFE) ───────────────────────
#   • All *.sh in ~/.extras are sourced in lexical order.
#   • A missing dir is silently ignored.
#   • An individual script that exits non‑zero prints a warning
#     but does NOT abort shell start‑up.
if [[ -d "$HOME/.extras" ]]; then
  for _extra in "$HOME"/.extras/*.sh(N); do    # (N) → no‑match expands to null
    if [[ -r "$_extra" ]]; then
# shellcheck source=/dev/null
      . "$_extra" || printf '[.extras] %s exited with code %d\n' "$_extra" "$?" >&2
    fi
  done
fi

# execute commands on the host from within the container
host() {
  distrobox-host-exec env NO_DISTROBOX_AUTOENTER=1 "$@"
}

# reset or update the container
reset-dev {
  host systemctl --user start reset-hyprome.service
}

setup-dev {
  if [ -z "$container" ]; then
    systemctl --user stop hyprome-dev
    podman pull ghcr.io/rom3dius/hyprome-dev:latest
    systemctl --user start hyprome-dev
  else
    echo "Cannot be run in a container!"
  fi
}

if [ -z "$container" ] && [ -z "$NO_DISTROBOX_AUTOENTER" ] && [ -n "$PS1" ]; then
  CONTAINER_NAME="hyprome-dev-distrobox-quadlet"

  if podman container exists "$CONTAINER_NAME"; then
    if [ "$(podman inspect -f '{{.State.Running}}' "$CONTAINER_NAME" 2>/dev/null)" = "true" ]; then
      exec distrobox enter "$CONTAINER_NAME"
    fi
  fi

  fastfetch -c "$HOME/.config/fastfetch/config-compact.jsonc"

  echo "⚠️ Container '$CONTAINER_NAME' is not running yet."
  echo "  Try running `setup-dev` and restarting your shell."
fi
