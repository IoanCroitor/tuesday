
#!/bin/bash

while true; do
  read -n 1 -s key
  case "$key" in
    w) echo "Up";;
    s) echo "Down";;
    a) echo "Left";;
    d) echo "Right";;
    q) echo "Quit"; break;;
  esac
done
