#!/bin/sh

#------------------------------------------------------------------------------
# Source xinitrc.d scripts:
#------------------------------------------------------------------------------

if [ -d /etc/X11/xinit/xinitrc.d ]; then
  for i in /etc/X11/xinit/xinitrc.d/*; do
    [ -x "${i}" ] && . "${i}"
  done
fi

#------------------------------------------------------------------------------
# VirtualBox guest services:
#------------------------------------------------------------------------------

[ -x /usr/bin/VBoxClient-all ] && /usr/bin/VBoxClient-all &

#------------------------------------------------------------------------------
# Load .Xresources:
#------------------------------------------------------------------------------

[ -f ${HOME}/.Xresources ] && xrdb -merge ${HOME}/.Xresources

#------------------------------------------------------------------------------
# Setting keyboard layout (setxkbmap -print -verbose 10):
#------------------------------------------------------------------------------

setxkbmap -model pc104 -layout es

#------------------------------------------------------------------------------
# Adjusting typematic delay and rate:
#------------------------------------------------------------------------------

xset r rate 200 30

#------------------------------------------------------------------------------
# Add fonts paths:
#------------------------------------------------------------------------------

xset fp default
[ -d ${HOME}/.fonts ] && xset +fp ${HOME}/.fonts
xset fp rehash

#------------------------------------------------------------------------------
# Start apps in background (only if not already running)
#------------------------------------------------------------------------------

list=(urxvtd statusbar)

for app in "${list[@]}"; do
  check=$(ps -C "${app}" -opid=)
  if [[ -z "${check}" ]]; then
    case "${app}" in
      urxvtd)    urxvtd -q -o -f ;;
      statusbar) statusbar & ;;
      clipster)  clipster -d & ;;
    esac
  fi
done

#------------------------------------------------------------------------------
# Setup the monitors:
#------------------------------------------------------------------------------

MID=$(cat /etc/machine-id)

case ${MID} in

  #-------------------
  # Lenovo X1 Carbon:
  #-------------------

  d70d8472bb6848b2a6c38ce2b53e59e5)

    # Laptop screen modes:
    xrandr --newmode "1600x900"  118.25  1600 1696 1856 2112  900 903 908 934 -hsync +vsync; xrandr --addmode LVDS1 1600x900
    xrandr --newmode "1368x768"   85.25  1368 1440 1576 1784  768 771 781 798 -hsync +vsync; xrandr --addmode LVDS1 1368x768
    xrandr --newmode "1280x720"   74.50  1280 1344 1472 1664  720 723 728 748 -hsync +vsync; xrandr --addmode LVDS1 1280x720
    xrandr --newmode "1024x576"   46.50  1024 1064 1160 1296  576 579 584 599 -hsync +vsync; xrandr --addmode LVDS1 1024x576
    xrandr --newmode "960x540"    40.75   960  992 1088 1216  540 543 548 562 -hsync +vsync; xrandr --addmode LVDS1 960x540
    xrandr --newmode "856x480"    31.75   856  880  960 1064  480 483 493 500 -hsync +vsync; xrandr --addmode LVDS1 856x480
    xrandr --newmode "640x360"    18.00   640  664  720  800  360 363 368 376 -hsync +vsync; xrandr --addmode LVDS1 640x360

    # External extends (1920x1080 no panning):
    xrandr | grep -q 'DP1 connected' && xrandr \
    --output LVDS1 --mode 1600x900 \
    --output DP1 --mode 1920x1080 --above LVDS1
    ;;

  #-------------
  # VirtualBox:
  #-------------

  b422c3b66842496db5307e940c28767a)

    # Map middle mouse button:
    xmodmap -e "keycode 134 = Pointer_Button2"
    xkbset m

    # Setup monitors:
    xrandr | grep -q VGA-2 && xrandr \
    --output VGA-1 --mode 1680x1050 --pos 0x0 --primary --output VGA-2 \
    --mode 1680x1050 --pos 1680x0 || xrandr --output VGA-1 --mode 1440x900
    ;;

esac

#------------------------------------------------------------------------------
# Start the WM:
#------------------------------------------------------------------------------

exec dwm
