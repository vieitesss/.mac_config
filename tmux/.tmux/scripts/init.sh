#!/bin/bash

if [[ ! "$(tmux list-clients | wc -l)" -ge "1" ]]; then
    # echo "No hay clientes"
    TMUX='' tmux attach
fi
