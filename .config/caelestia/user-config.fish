# Sourced at the end of caelestia's fish/config.fish (see manifest.toml's
# `fish` component post_install hook, which creates this file). Ported from
# the old .zshrc — anything caelestia's own config.fish already provides
# (starship, zoxide, direnv, eza ls/git abbrs) is intentionally not repeated.

set -gx EDITOR nvim
set -gx TERM xterm-256color

# yadm decrypt on shell start if the encrypted archive changed
function decrypt_yadm_if_needed
    set -l enc_file $HOME/.local/share/yadm/archive
    set -l hash_file $HOME/.cache/yadm-decrypt.hash

    mkdir -p $HOME/.cache

    if not test -f "$enc_file"
        return
    end

    set -l current_hash (sha256sum "$enc_file" | cut -d ' ' -f1)
    if not test -f "$hash_file"; or test "$current_hash" != (cat "$hash_file")
        echo "[yadm] Encrypted files changed. Decrypting..."
        and yadm decrypt
        and echo "$current_hash" >"$hash_file"
    end
end

if not set -q container
    decrypt_yadm_if_needed
end

# brew
if not set -q BREW_LOADED
    set -l hb /home/linuxbrew/.linuxbrew/bin/brew
    if test -x $hb
        eval ($hb shellenv)
        set -gx BREW_LOADED 1
    end
end

fish_add_path -g $HOME/.local/bin

# archives
function extract
    if test (count $argv) -eq 0
        echo "Usage: extract <path/file_name>.<zip|rar|bz2|gz|tar|tbz2|tgz|Z|7z|xz|exe|tar.bz2|tar.gz|tar.xz>"
        return
    end
    set -l f $argv[1]
    if not test -f $f
        echo "$f - file does not exist"
        return
    end
    switch $f
        case '*.tar.bz2'
            tar xvjf $f
        case '*.tar.gz'
            tar xvzf $f
        case '*.tar.xz'
            tar xvJf $f
        case '*.lzma'
            unlzma $f
        case '*.bz2'
            bunzip2 $f
        case '*.rar'
            unrar x -ad $f
        case '*.gz'
            gunzip $f
        case '*.tar'
            tar xvf $f
        case '*.tbz2'
            tar xvjf $f
        case '*.tgz'
            tar xvzf $f
        case '*.zip'
            unzip $f
        case '*.Z'
            uncompress $f
        case '*.7z'
            7z x $f
        case '*.xz'
            unxz $f
        case '*.exe'
            cabextract $f
        case '*'
            echo "extract: '$f' - unknown archive method"
    end
end
alias extr='extract'

function extract_and_remove
    extract $argv[1]
    rm -f $argv[1]
end
alias extrr='extract_and_remove'

alias fperm='stat -c "%a %n"'
alias update-dots='yadm clone -f https://github.com/Rom3dius/hyprome-dev-dots && yadm checkout $HOME'

# yazi wrapper (cd on exit)
function yy
    set -l tmp (mktemp -t "yazi-cwd.XXXXXX")
    yazi $argv --cwd-file="$tmp"
    set -l cwd (cat -- "$tmp")
    if test -n "$cwd"; and test "$cwd" != "$PWD"
        builtin cd -- "$cwd"
    end
    rm -f -- "$tmp"
end

# yazi plugins (auto-install)
if command -v ya &>/dev/null
    set -l yazi_plugins "yazi-rs/plugins:jump-to-char" "yazi-rs/plugins:smart-enter" "yazi-rs/plugins:chmod"
    set -l yazi_plugin_dir $HOME/.config/yazi/plugins
    set -l need_install false

    for p in $yazi_plugins
        set -l name (string split -r -m1 ':' $p)[2]
        if not test -d "$yazi_plugin_dir/$name.yazi"
            set need_install true
            break
        end
    end

    if $need_install
        echo "[yazi] Installing missing plugins..."
        for p in $yazi_plugins
            ya pkg add $p 2>/dev/null
        end
    end
end

# ~/.extras overrides — same convention as the old .zshrc: every *.fish in
# ~/.extras is sourced in lexical order; a missing dir is silently ignored.
if test -d $HOME/.extras
    for extra in $HOME/.extras/*.fish
        if test -r "$extra"
            source "$extra"; or printf '[.extras] %s exited with a non-zero status\n' "$extra" >&2
        end
    end
end

if status is-interactive
    fastfetch -c "$HOME/.config/fastfetch/config-compact.jsonc"
end
