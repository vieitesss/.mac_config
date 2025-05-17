#!/bin/sh

usage=$(ps -A -o %mem | awk '{s+=$1} END {print int(s) "%"}')

sketchybar --set "$NAME" label="$usage"
