#!/bin/sh

#---------------------------------------------------------
# Source xinitrc.d scripts:
#---------------------------------------------------------

if [ -d /etc/X11/xinit/xinitrc.d ]; then
  for f in /etc/X11/xinit/xinitrc.d/*; do
    [ -x "$f" ] && . "$f"
  done
fi

#----------------------------
# VirtualBox guest services:
#----------------------------

[[ -x /usr/bin/VBoxClient-all ]] && /usr/bin/VBoxClient-all &

#-----------------
# Setup monitors:
#-----------------

UUID=`cat /etc/uuid`

case $UUID in

  #-------------------
  # Lenovo X1 Carbon:
  #-------------------

  3609b77f-fc2a-4773-8f11-f035465f725e)

    # Laptop screen modes:
    xrandr --newmode "1600x900"  118.25  1600 1696 1856 2112  900 903 908 934 -hsync +vsync; xrandr --addmode LVDS1 1600x900
    xrandr --newmode "1368x768"   85.25  1368 1440 1576 1784  768 771 781 798 -hsync +vsync; xrandr --addmode LVDS1 1368x768
    xrandr --newmode "1280x720"   74.50  1280 1344 1472 1664  720 723 728 748 -hsync +vsync; xrandr --addmode LVDS1 1280x720
    xrandr --newmode "1024x576"   46.50  1024 1064 1160 1296  576 579 584 599 -hsync +vsync; xrandr --addmode LVDS1 1024x576
    xrandr --newmode "960x540"    40.75   960  992 1088 1216  540 543 548 562 -hsync +vsync; xrandr --addmode LVDS1 960x540
    xrandr --newmode "856x480"    31.75   856  880  960 1064  480 483 493 500 -hsync +vsync; xrandr --addmode LVDS1 856x480
    xrandr --newmode "640x360"    18.00   640  664  720  800  360 363 368 376 -hsync +vsync; xrandr --addmode LVDS1 640x360

    # External extends (1920x1080 no panning):
    #xrandr | grep -q 'DP1 connected' && {
    #  xrandr --output LVDS1 --mode 1600x900
    #  xrandr --output DP1 --mode 800x600 --above LVDS1
    #}

    # External extends (1920x1080 no panning):
    xrandr | grep -q 'DP1 connected' && xrandr \
    --output LVDS1 --mode 1600x900 \
    --output DP1 --mode 1920x1080 --above LVDS1

    # External mirrors (640x480 panning 1600x900):
    #xrandr | grep -q 'DP1 connected' && xrandr \
    #--output LVDS1 --mode 1600x900 \
    #--output DP1 --mode 800x600 --panning 1600x900 --same-as LVDS1
    ;;

  #----------------------
  # Dell Latitude E6410:
  #----------------------

  6902f136-288b-4941-a750-5781d2117e1a)

    xrandr | grep -q 'HDMI1 connected' && {

      # Turn off laptop screen:
      xrandr --output eDP1 --off

      # Setup docking station:
      xrandr --output VGA1 --mode 1280x1024
      xrandr --output HDMI1 --mode 1680x1050 --right-of VGA1
    }
    ;;

esac

#-------------------
# Load .Xresources:
#-------------------

[[ -f $HOME/.Xresources ]] && xrdb -merge $HOME/.Xresources

#---------------------------------------------------------
# Setting keyboard layout (setxkbmap -print -verbose 10):
#---------------------------------------------------------

setxkbmap -model pc104 -layout es

#------------------
# Add fonts paths:
#------------------

xset fp default
[[ -d $HOME/.fonts ]] && xset +fp $HOME/.fonts
xset fp rehash

#--------------------------------------------------------
# Start apps in background (only if not already running)
#--------------------------------------------------------

list=(urxvtd statusbar clipster)

for app in "${list[@]}"; do
  check=$(ps -C "$app" -opid=)
  if [[ -z "$check" ]]; then
    case "$app" in
      urxvtd)    urxvtd -q -o -f ;;
      statusbar) statusbar & ;;
      clipster)  clipster -d & ;;
    esac
  fi
done

#---------------
# Start the WM:
#---------------

exec dwm
