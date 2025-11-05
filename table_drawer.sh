#!/bin/bash

# This function is now just for a simple separator, the custom one is in main.sh
write_separator_line() {
    local -a column_lengths=("${!1}")
    printf '%s' "$table_border_mark"
    for length in "${column_lengths[@]}"; do
        printf "%*s" $((length + 2)) "" | tr ' ' "$table_horizontal_separator"
        printf '%s' "$table_border_mark"
    done
    printf '\n'
}

write_row() {
    local -a column_lengths=("${!1}")
    local -a values=("${!2}")
    local -a colors=("${!3}")
    local column_count=${#column_lengths[@]}

    printf '%s' "$table_vertical_separator"
    for ((i=0; i<column_count; i++)); do
        local cell_content="${values[i]:-}"
        local cell_color="${colors[i]:-}"
        local cell_width=${column_lengths[i]}

        # --- THIS IS THE CRITICAL FIX ---
        local colored_text
        if [ -n "$cell_color" ]; then
            # If a color name IS provided (e.g., "white"), color the text.
            colored_text=$(get_colored_string "$cell_content" "$cell_color")
        else
            # If color name is EMPTY (""), use the content AS-IS.
            # This correctly passes the pre-colored lolcat arrow through without breaking it.
            colored_text="$cell_content"
        fi
        # --- END OF FIX ---

        # Calculate padding based on the VISIBLE length of the content
        local clean_content
        clean_content=$(echo -n "$cell_content" | sed 's/\x1b\[[0-9;]*m//g')
        local padding=$((cell_width - ${#clean_content}))
        
        # Print the cell with correct padding
        printf ' %s' "$colored_text"
        if (( padding > 0 )); then
            printf '%*s' "$padding" ''
        fi
        printf ' %s' "$table_vertical_separator"
    done
    printf '\n'
}