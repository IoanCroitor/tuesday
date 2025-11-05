#!/bin/bash

set -e

source ./color_printer.sh
source ./table_drawer.sh

rng=$RANDOM

display_events_table() {
    # --- TABLE CONFIGURATION (CHANGED) ---
    # Added a new 5-character wide column at the start for the arrow
    local -a column_lengths=(5 13 35 10 15)
    local table_vertical_separator="|"
    local table_horizontal_separator="-"
    local table_border_mark="*"
    # Added an empty header for the new column
    local -a headers=("" "Time" "Event" "Location" "Calendar")
    local -a header_colors=("white" "white" "white" "white" "white")
    # --- RENDER HEADER ---
    write_separator_line column_lengths[@]
    write_row column_lengths[@] headers[@] header_colors[@]
    write_separator_line column_lengths[@]
    # --- RENDER BODY ---
    if [ "${#Events[@]}" -eq 0 ]; then
        # Added an empty field for the new column
        local -a no_events_data=("" "" "No events found" "" "")
        write_row column_lengths[@] no_events_data[@]
    else
        # --- NEW: Get current time info, but ONLY if we are viewing today's schedule ---
        local is_today=false
        local current_time=""
        if [[ "$TARGET_DATE" == $(date +%F) ]]; then
            is_today=true
            current_time=$(date +%H:%M)
        fi
        for i in "${!Events[@]}"; do
            # --- FIXED: Ensure indicator cell has correct visible width ---
            local indicator_cell="     " # Default: 5 spaces to match column width
            if [[ "$is_today" == true && "${StartTimes[i]}" < "$current_time" && "${EndTimes[i]}" > "$current_time" ]]; then
                # Pad to 5 chars before piping to lolcat so visible width is correct
                indicator_cell=$(printf " %-3s " "-->" | lolcat)
            fi
            
            local -a row_data=(
                "$indicator_cell" 
                "${StartTimes[i]} - ${EndTimes[i]}"
                "${Events[i]}"
                "${Locations[i]}"
                "${Groups[i]}"
            )
            # --- CHANGED: Set color for the indicator cell to "" (empty) so it isn't re-colored ---
            local -a row_colors=( "" "white" "${Colors[i]}" "${Colors[i]}" "${Colors[i]}" )
            
            write_row column_lengths[@] row_data[@] row_colors[@]
        done
    fi
    write_separator_line column_lengths[@]
}
redraw_screen() {
    clear
    if [[ "$MODE" == "full" ]]; then
        source ./print_banner.sh ${TARGET_DATE} $rng
        source ./print_calendar_status.sh 
    fi
    
    source ./read_and_process.sh "$TARGET_DATE"
    
    display_events_table

    if [[ "$MODE" == "full" ]]; then
        echo "◄ [a/d] ► Navigate | [c] Current | [e] Edit | [q] Quit"
    fi
}

shift_date() {
    local input_date="$1"
    local shift_amount="$2"
    date -I -d "$input_date $shift_amount day"
}

handle_action() {
    local action="$1"
    local needs_redraw=true

    case "$action" in
        "Previous Day")
            TARGET_DATE=$(shift_date "$TARGET_DATE" -1)
            ;;
        "Next Day")
            TARGET_DATE=$(shift_date "$TARGET_DATE" +1)
            ;;
        "Current Date")
            TARGET_DATE=$(date +%F)
            ;;
        "Edit Active Calendars")
            source ./edit_active_calendars.sh
            ;;
        *)
            needs_redraw=false
            ;;
    esac
    
    if [[ "$needs_redraw" == true ]]; then
        redraw_screen
    fi
}

date_handler() {
    while true; do
        read -s -n 1 -r key
        if [[ "$key" == $'\e' ]]; then
            read -s -n 2 -r -t 0.1 rest
            key+="$rest"
        fi
        case "$key" in
            'a' | $'\e[D') handle_action "Previous Day";;
            'd' | $'\e[C') handle_action "Next Day";;
            'c' | 'n')      handle_action "Current Date";;
            'e')            handle_action "Edit Active Calendars";;
            'q')            echo "Quitting, see you next time!"; break;;
        esac
    done
}

init() {
    MODE="full"
    TARGET_DATE=$(date +%F)

    if [[ "$1" == "-m" ]]; then
        MODE="minimal"
        if [[ -n "$2" ]]; then
            TARGET_DATE="$2"
        fi
    elif [[ -n "$1" ]]; then
        TARGET_DATE="$1"
    fi

    redraw_screen

    if [[ "$MODE" == "full" ]]; then
        date_handler
    fi
}

init "$@"