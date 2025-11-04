#!/bin/bash


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

        local colored_text
        colored_text=$(get_colored_string "$cell_content" "$cell_color")

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