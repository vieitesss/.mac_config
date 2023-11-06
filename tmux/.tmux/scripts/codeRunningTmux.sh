#!/bin/bash

if [[ $(code --status | grep tmux | wc -l | awk '{print $1}') -eq 1 ]]; then
    echo 1
else
    echo 0
fi
