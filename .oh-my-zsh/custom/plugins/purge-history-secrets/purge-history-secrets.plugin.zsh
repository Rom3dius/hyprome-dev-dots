#!/bin/zsh

# Author: jotasixto (adapted)
# Modified: Runs without cron; works in containers and regular shells

function check_history_lines() {
    gitleaks detect --no-git --log-level fatal -f json --no-color --no-banner --redact --source ~/.zsh_history -r ~/.report_gitleaks.json

    local -a line_numbers_array
    line_numbers_array=($(jq '.[].StartLine' ~/.report_gitleaks.json 2>/dev/null))

    rm -f ~/.report_gitleaks.json

    if [[ ${#line_numbers_array[@]} -eq 0 ]]; then
        return
    fi

    sorted_line_numbers=($(printf "%s\n" "${line_numbers_array[@]}" | sort -rn))

    for number in "${sorted_line_numbers[@]}"; do
        line_content=$(sed -n "${number}p" ~/.zsh_history 2>/dev/null)
        if [[ $? -ne 0 ]]; then
            echo "Error reading line $number from ~/.zsh_history." >&2
            continue
        fi

        sed -i "${number}d" ~/.zsh_history
        echo "$(date '+%Y-%m-%d %H:%M:%S') - $number line purged from history" >> ~/.purge-secrets-zshhistory.log
    done
}

function start_purge_loop() {
    # Avoid duplicate background loops
    if [[ -n "${PURGE_HISTORY_LOOP_RUNNING:-}" ]]; then
        return
    fi

    export PURGE_HISTORY_LOOP_RUNNING=1

    # Run every minute in background
    {
        while true; do
            check_history_lines
            sleep 30
        done
    } &
}

