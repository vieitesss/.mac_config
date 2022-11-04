#!/bin/bash

step=40

case "$1" in
    west) dir=right; falldir=left; x="-$step"; y=0
    ;;
    east) dir=right; falldir=left; x="$step"; y=0   
    ;;
    north) dir=top; falldir=bottom; x=0; y="-$step"  
    ;;
    south) dir=top; falldir=bottom; x=0; y="$step"  
    ;;
esac

yabai -m window --resize $dir:$x:$y || yabai -m window --resize $falldir:$x:$y
