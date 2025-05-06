# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="agnoster"

plugins=(
  git
  dnf
  kitty
  extract
  podman
)

source "$ZSH/oh-my-zsh.sh"

# ───────────────────────────────── fastfetch ──────────────────────────────────
fastfetch -c "$HOME/.config/fastfetch/config-compact.jsonc"

# ────────────────────────────────── fzf key‑bindings ─────────────────────────
source <(fzf --zsh)

# ────────────────────────────────── history / PATH ────────────────────────────
HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
setopt appendhistory

path+=('~/.local/bin')

# ───────────────────────────── pretty ls via lsd ──────────────────────────────
alias ls='lsd'
alias l='ls -l'
alias la='ls -a'
alias lla='ls -la'
alias lt='ls --tree'

# Custom aliases
alias fperm='stat -c "%a %n"'

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
