#!/bin/bash

if [ $# -eq 0 ]; then
    echo "Usage: $0 <path_to_wallpaper>"
    exit 1
fi

command="tell application \"Finder\"
set desktop picture to POSIX file \"$1\"
end tell
tell application \"System Events\"
tell application \"System Settings\"
activate
end tell
delay 0.3
tell process \"System Settings\"
delay 0.3
click menu item \"Wallpaper\" of menu \"View\" of menu bar 1
delay 0.7
click checkbox \"Show on all Spaces\" of group 2 of scroll area 1 of group 1 of group 2 of splitter group 1 of group 1 of window \"Wallpaper\"
end tell
delay 0.3
tell application \"System Settings\"
activate
end tell
delay 0.3
tell process \"System Settings\"
delay 0.3
click menu item \"Wallpaper\" of menu \"View\" of menu bar 1
delay 0.5
click checkbox \"Show on all Spaces\" of group 2 of scroll area 1 of group 1 of group 2 of splitter group 1 of group 1 of window \"Wallpaper\"
end tell
delay 0.3
tell application \"System Settings\"
quit
end tell
end tell
"

osascript -e "$command"
