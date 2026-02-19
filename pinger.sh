#!/bin/bash

function ping_host {
    url="$1"

    if ping -c 1 -W 2 "$url" > /dev/null 2>&1; then 
        echo "$url доступен!"
        return 0
    else 
        echo "$url  упал :("
        return 1
    fi
}

ping_host "google.com"
ping_host "aboba"