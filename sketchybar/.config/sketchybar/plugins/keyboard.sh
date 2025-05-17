#!/bin/sh

sleep 0.5

selected=$(defaults read ~/Library/Preferences/com.apple.HIToolbox.plist AppleSelectedInputSources |
	grep -i "keyboardlayout name" |
	cut -d= -f2 |
	tr -d "\";" |
	xargs -I% echo %)
	
sketchybar --set "$NAME" label="$selected"
