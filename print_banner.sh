#!/bin/bash

# cat <<'EOF' | lolcat
#   _______                          _               
#  '   /    ,   .   ___    ____   ___/   ___  ,    . 
#      |    |   | .'   `  (      /   |  /   ` |    ` 
#      |    |   | |----'  `--.  ,'   | |    | |    | 
#      /    `._/| `.___, \___.' `___,' `.__/|  `---|.
#                                    `         \___/ 
# EOF


target_date="${1:-today}"

weekday=$(date -d "$target_date" +%A)

figlet -f script $weekday | lolcat --seed $2

echo -e "\e[0;35m$(date -d $target_date +%d-%m-%Y)\e[0m"