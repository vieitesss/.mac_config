#!/usr/bin/env bash

function sshpi {
    local pip
    pip=$(sudo nmap -sS --min-rate 5000 -n 192.168.1.0/24 |
        grep -e "Nmap scan report" -e "Raspberry" |
        grep -B 1 "Raspberry" |
        head -n 1 |
        cut -d" " -f5
    )

    if [[ -z "$pip" ]]; then
        echo "Raspberry Pi not found on the network."
        return
    fi

    ssh vieitesrpi@"$pip"
}
