#!/bin/bash


ACTIVE_CALENDARS=(
)

INACTIVE_CALENDARS=(
)


print_available_calendars() {
    local -n active_ref=$1
    local -n inactive_ref=$2

    echo "Your calendars:"
    for calendar in "${active_ref[@]}"; do
        echo '[x]' "$calendar"
    done

    for calendar in "${inactive_ref[@]}"; do
        echo '[ ]' "$calendar"
    done
}


shopt -s globstar
for f in ./calendars/**; do
    if [ -f "$f" ] && [[ "$f" == *.csv ]]; then
        name="$(basename "$f" .csv)"

        if [[ "$f" == ./calendars/active/* ]]; then
            ACTIVE_CALENDARS+=("$name")
        elif [[ "$f" == ./calendars/inactive/* ]]; then
            INACTIVE_CALENDARS+=("$name")
        fi
    fi
done


print_available_calendars ACTIVE_CALENDARS INACTIVE_CALENDARS