#!/bin/sh

if [[ -z "$FOCUSED" ]]
then
	FOCUSED=$(aerospace list-workspaces --focused)
fi

# not_empty=$(aerospace list-workspaces --monitor 1 --empty no)
#
# CURRENT=""
# NOT_EMPTY=""
# EMPTY=""

# if [[ "aerospace.$current" == "$NAME" ]]
# then
# 	sketchybar --set "$NAME" icon="$FOCUSED" icon.color=0xffcba6f7
# elif [[ "$not_empty" =~ "$number" ]]
# then
# 	sketchybar --set "$NAME" icon="$NOT_EMPTY" icon.color=0xffcba6f7
# else
# 	sketchybar --set "$NAME" icon="$EMPTY" icon.color=0xffcdd6f4
# fi
color="0xffcdd6f4"

default=(
	icon.background.color="$color"
	icon.background.height=10
	icon.background.corner_radius=10
	icon.padding_right=5
	icon.padding_left=5
)

focused=(
	icon.background.drawing=true
	# icon.background.color=0xffcdd6f4 # Dark
	icon.background.color="$color"
	icon.background.height=16
	icon.background.corner_radius=10
	icon.padding_right=20
	icon.padding_left=20
)

if [[ "aerospace.$FOCUSED" == "$NAME" ]]
then
	sketchybar --set "$NAME" "${focused[@]}"
else
	sketchybar --set "$NAME" "${default[@]}"
fi
