#!/bin/sh

xrandr | grep 'DP1 connected' && xrandr --output LVDS1 --mode 1600x900 --output DP1 --mode 1920x1080 --above LVDS1 &
