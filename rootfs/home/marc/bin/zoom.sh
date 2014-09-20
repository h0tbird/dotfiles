#!/bin/sh

#-------------------
# Get current mode:
#-------------------

declare -A hash
current=`xrandr | grep '*' | awk '{print $1}'`

case $1 in

    #----------
    # Zoom In:
    #----------

    'in')
    hash[1600x900]='1368x768'
    hash[1368x768]='1280x720'
    hash[1280x720]='1024x576'
    hash[1024x576]='960x540'
    hash[960x540]='856x480'
    hash[856x480]='640x360'
    hash[640x360]='1600x900';;

    #-----------
    # Zoom Out:
    #-----------

    'out')
    hash[1600x900]='640x360'
    hash[1368x768]='1600x900'
    hash[1280x720]='1368x768'
    hash[1024x576]='1280x720'
    hash[960x540]='1024x576'
    hash[856x480]='960x540'
    hash[640x360]='856x480';;

    #----------
    # Zoom To:
    #----------

    1)  hash[$current]='1600x900';;
    2)  hash[$current]='1368x768';;
    3)  hash[$current]='1280x720';;
    4)  hash[$current]='1024x576';;
    5)  hash[$current]='960x540';;
    6)  hash[$current]='856x480';;
    7)  hash[$current]='640x360';;

esac

#--------------
# Switch mode:
#--------------

xrandr --output LVDS1 --mode ${hash[$current]} --panning 1600x900
