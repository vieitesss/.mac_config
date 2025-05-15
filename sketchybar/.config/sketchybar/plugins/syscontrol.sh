#!/usr/bin/env bash

ACTION="$1"

# Check that a valid argument was provided
if [[ "$ACTION" != "restart" && "$ACTION" != "down" ]]; then
  echo "Usage: $0 [restart|down]"
  exit 1
fi

# Set the confirmation message based on the action
if [[ "$ACTION" == "restart" ]]; then
  MESSAGE="Are you sure you want to reboot the system?"
else
  MESSAGE="Are you sure you want to shut down the system?"
fi

# Show AppleScript confirmation dialog and capture the button pressed
CHOICE=$(osascript <<EOF
tell application "System Events"
  activate
  set dialogResult to display dialog "$MESSAGE" buttons {"No", "Yes"} default button "No" with icon caution
  return button returned of dialogResult
end tell
EOF
)

# Perform the action if the user confirmed
if [[ "$CHOICE" == "Yes" ]]; then
  if [[ "$ACTION" == "restart" ]]; then
    sudo shutdown -r now
  else
    sudo shutdown -h now
  fi
else
  echo "Operation cancelled."
fi
