#!/bin/bash

clear

echo "Calendar TUI - About"
echo "---------------------"
echo -e "Made with \033[31m♥\033[0m by:"
echo " - Constantinescu Sonia"
echo " - Croitor Ioan"
echo " - x Mario"
echo ""

echo ""
echo "Press [r] to return or [q] to quit."

while true; do
    read -s -n 1 -r key
    case "$key" in
        'r'|'R')
            exec ./main.sh
            ;;
        'q'|'Q')
            echo "Quitting, see you next time!"
            exit 0
            ;;
    esac
done
