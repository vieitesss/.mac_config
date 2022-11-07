#!/bin/bash

comando="tmux ls"

$comando > /dev/null

if [[ "$(echo $?)" == "1" ]]; then
    tmux
else
    tmux attach -t $($comando | head -n 1 | awk '{print substr($1, 1, length($1) - 1)}')
fi
