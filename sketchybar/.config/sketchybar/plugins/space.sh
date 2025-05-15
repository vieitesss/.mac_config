#!/bin/sh

current=$(aerospace list-workspaces --focused)

if [[ "aerospace.$current" == "$NAME" ]]
then
	sketchybar --set "$NAME" icon.color=0xffefde6f
else
	sketchybar --set "$NAME" icon.color=0xffffffff
fi
