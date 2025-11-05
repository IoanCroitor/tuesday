#!/bin/bash

edit_active_calendars() {
    while true; do

        local -a ALL_CALENDARS=()
        local -a ACTIVE_CALENDARS=()


        while IFS= read -r -d '' file; do
            ALL_CALENDARS+=("$(basename "$file" .csv)")
        done < <(find ./calendars/ -name "*.csv" -print0 | sort -z | uniq -z)
        
      
        for f in ./calendars/active/*.csv; do
            [ -f "$f" ] && ACTIVE_CALENDARS+=("$(basename "$f" .csv)")
        done

        clear
        echo "------ Edit Calendars ------"
        if [ ${#ALL_CALENDARS[@]} -eq 0 ]; then
            echo "No calendars found."
        else
            for i in "${!ALL_CALENDARS[@]}"; do
                local calendar_name="${ALL_CALENDARS[i]}"
                local status="[ ]" # Default to inactive

                if [[ " ${ACTIVE_CALENDARS[*]} " =~ " ${calendar_name} " ]]; then
                    status="[x]"
                fi
                printf "%2d. %s %s\n" "$((i + 1))" "$status" "$calendar_name"
            done
        fi
        echo "----------------------------"

        echo 'Enter number to toggle, [e] to go back or [q] to exit: '
        read -s -n 1 choice

        case "$choice" in
            q|Q)
                echo "Exiting, see you next time!"
                exit 0
                ;;
            e|E)
                source ./main.sh
                ;;
            *)
                if ! [[ "$choice" =~ ^[0-9]+$ ]] || [ "$choice" -lt 1 ] || [ "$choice" -gt "${#ALL_CALENDARS[@]}" ]; then
                    echo "Invalid input: '$choice'. Please try again."
                    sleep 2 
                    continue 
                fi

                local index=$((choice - 1))
                local calendar_to_toggle="${ALL_CALENDARS[index]}"

                if [[ " ${ACTIVE_CALENDARS[*]} " =~ " ${calendar_to_toggle} " ]]; then
                    mv "./calendars/active/${calendar_to_toggle}.csv" "./calendars/inactive/"
                    
                else
                    mv "./calendars/inactive/${calendar_to_toggle}.csv" "./calendars/active/"
                    
                fi
                ;;
        esac
    done
}


edit_active_calendars