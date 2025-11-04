#!/bin/bash

# Exit immediately if a command exits with a non-zero status.
set -e
# Treat unset variables as an error when substituting.

# --- Source all function libraries ---
source ./color_printer.sh
source ./table_drawer.sh

# --- Main Display Function ---
display_events_table() {
    # --- Table Configuration ---
    local -a column_lengths=(13 35 10 15)
    local table_vertical_separator="|"
    local table_horizontal_separator="-"
    local table_border_mark="*"


    local -a headers=("Time" "Event" "Location" "Calendar")
    local -a header_colors=("white" "white" "white" "white")

    write_separator_line column_lengths[@]
    write_row column_lengths[@] headers[@] header_colors[@]
    write_separator_line column_lengths[@]

   if [ "${#Events[@]}" -eq 0 ]; then
        local -a no_events_data=("No events found for this date." "" "" "")
        write_row column_lengths[@] no_events_data[@]
    else
        for i in "${!Events[@]}"; do
            local -a row_data=(
                "${StartTimes[i]} - ${EndTimes[i]}"
                "${Events[i]}"
                "${Locations[i]}"
                "${Groups[i]}"
            )

            local -a row_colors=(
                "white"
                "${Colors[i]}"
                "${Colors[i]}"
                "${Colors[i]}"
            )

            write_row column_lengths[@] row_data[@] row_colors[@]
        done
    fi

    write_separator_line column_lengths[@]
}


init() {
    clear
    local CURRENT_DATE=$1

    source ./print_banner.sh

    source ./print_calendar_status.sh
    source ./read_and_process.sh "$CURRENT_DATE"

    
    display_events_table
}

# --- Main execution starts here ---

if [ $# -eq 0 ]; then
    TARGET_DATE=$(date +%F)
else
    TARGET_DATE="$1"
fi
init "$TARGET_DATE"





# Your test function remains unchanged
test(){
    options=("Option 1" "Option 2" "Option 3" "Quit")
    select opt in "${options[@]}"
    do
        case $opt in
            "Option 1")
                clear
                echo "you chose choice 1"
                test
                ;;
            "Option 2")
                echo "you chose choice 2"
                ;;
            "Option 3")
                echo "you chose choice $REPLY which is $opt"
                ;;
            "Quit")
                break
                ;;
            *) echo "invalid option $REPLY";;
        esac
    done
}






SHOW_DATE='2025-11-04'

date_handler(){
    while true; do
        read -n 1 -s key
        case "$key" in
            a|"^[[D^") echo "Prev";;
            d|"^[[C^") echo "Next";;
            c|n) echo "Current";;
            e) echo "Edit";;
            q) echo "Quit"; break;;
        esac
    done

}

date_handler