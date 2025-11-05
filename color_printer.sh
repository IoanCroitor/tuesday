#!/bin/bash

get_colored_string() {
    local text="$1"
    local color_name="$2"
    local color_code=""

    case "${color_name,,}" in
        "black")         color_code="0;30" ;;
        "darkgray")      color_code="1;30" ;;
        "red")           color_code="0;31" ;;
        "lightred")      color_code="1;31" ;;
        "green")         color_code="0;32" ;;
        "lightgreen")    color_code="1;32" ;;
        "brown"|"orange") color_code="0;33" ;;
        "yellow")        color_code="1;33" ;;
        "blue")          color_code="0;34" ;;
        "lightblue")     color_code="1;34" ;;
        "purple")        color_code="0;35" ;;
        "lightpurple")   color_code="1;35" ;;
        "cyan")          color_code="0;36" ;;
        "lightcyan")     color_code="1;36" ;;
        "lightgray")     color_code="0;37" ;;
        "white")         color_code="1;37" ;;
        "pink")          color_code="38;5;206" ;;
        "violet")        color_code="38;5;171" ;;
        "teal")          color_code="38;5;43" ;;
        "lime")          color_code="38;5;154" ;;
        "magenta")       color_code="38;5;201" ;;
        *)               color_code="0" ;;
    esac

    printf '\e[%sm%s\e[0m' "$color_code" "$text"
}


print_color() {
    local text="$1"
    local color_name="$2"

    echo "$(get_colored_string "$text" "$color_name")"
}