#!/bin/sh

usage=$(ps -A -o %cpu | awk '{s+=$1} END {print int(s / 8) "%"}')

sketchybar --set "$NAME" label="$usage"
