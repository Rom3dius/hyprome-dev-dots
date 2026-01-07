#!/usr/bin/env bash
# Fixes 1Password + 1Password‑CLI group IDs and file permissions
# Works even if /usr/lib/sysusers.d/onepassword‑cli.conf is absent
# Tested on Fedora‑Atomic / uBlue‑OS builds

set -euo pipefail

# --- helper --------------------------------------------------------------

get_target_gid() {
  # $1 = path to sysusers.d file   $2 = numeric fallback
  local conf="$1" fallback="$2"
  if [[ -f "$conf" ]]; then
    awk '$1=="g"{print $3; exit}' "$conf"
  else
    echo "$fallback"
  fi
}

ensure_group() {
  # $1 = group name   $2 = desired gid
  local grp="$1" gid="$2"
  if getent group "$grp" &>/dev/null; then
    current_gid=$(getent group "$grp" | cut -d: -f3)
    if [[ "$current_gid" != "$gid" ]]; then
      echo "Changing GID of $grp from $current_gid → $gid"
      groupmod -g "$gid" "$grp"
    fi
  else
    echo "Creating group $grp with GID $gid"
    groupadd -r -g "$gid" "$grp"
  fi
}

add_user_to_group() {
  local grp="$1"
  if ! id -nG "$USER" | grep -qw "$grp"; then
    echo "Adding $USER to $grp (log out/in for it to take effect)"
    usermod -aG "$grp" "$USER"
  fi
}

fix_cli_binary() {
  local bin="/usr/bin/op"
  if [[ -e "$bin" ]]; then
    echo "Restoring ownership + set‑gid on $bin"
    chown root:onepassword-cli "$bin"
    chmod 2755 "$bin" # ‑rwxr‑sr‑x  (set‑gid)
  fi
}

# --- main ----------------------------------------------------------------

# Upstream RPMs default to 960 (desktop) and 961 (CLI).  Keep those as fallbacks.
OP_GID_FALLBACK=960
OPCLI_GID_FALLBACK=961

TARGET_OP_GID=$(get_target_gid /usr/lib/sysusers.d/onepassword.conf "$OP_GID_FALLBACK")
TARGET_OPCLI_GID=$(get_target_gid /usr/lib/sysusers.d/onepassword-cli.conf "$OPCLI_GID_FALLBACK")

ensure_group onepassword "$TARGET_OP_GID"
ensure_group onepassword-cli "$TARGET_OPCLI_GID"

fix_cli_binary
add_user_to_group onepassword-cli

echo "✔ 1Password GID/permission repair complete."
