#!/bin/bash

# Sin argumentos en el caso de simplemente querer saber el tipo de layout
if [ $# -eq 0 ]; then
    # Devuelve literalmente bsp o float
    type=$(yabai -m query --spaces | jq '.[] | select(.["has-focus"]) | .type' | sed -e 's/\"//g')
    case $type in
        "bsp")
            message="Tiling mode"
            ;;
        "float")
            message="Floating mode"
            ;;
    esac

    osascript -e "display notification \"$message\" with title \"Space layout\""
    exit 1
fi

osascript -e "display notification \"$1\" with title \"$2\""
