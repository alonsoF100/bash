#!/bin/bash

function ping_host {
    url="$1"

    if ping -c 1 -W 2 "$url" > /dev/null 2>&1; then 
        echo "$url доступен!"
        return 0
    else 
        return 1
    fi
}

network=$(hostname -I | cut -d "." -f1-3)

for ((i=0; i <= 255; i++)); do
    target="$network.$i"
    ping_host "$target"
done

