#!/bin/sh

if [[ -z "$FOCUSED" ]]
then
    FOCUSED=$(aerospace list-workspaces --focused)
fi

default=(
    icon.background.height=10
    icon.background.corner_radius=10
    icon.padding_right=5
    icon.padding_left=5
)

focused=(
    icon.background.drawing=true
    icon.background.height=16
    icon.background.corner_radius=10
    icon.padding_right=20
    icon.padding_left=20
)

if [[ "aerospace.$FOCUSED" == "$NAME" ]]
then
    sketchybar --animate linear 5 \
               --set "$NAME" "${focused[@]}"
elif [[ "aerospace.$PREV" == "$NAME" ]]
then
    sketchybar --animate linear 5 \
               --set "$NAME" "${default[@]}"
fi
