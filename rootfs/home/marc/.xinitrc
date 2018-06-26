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

case "$(cat /etc/machine-id)" in

  #-------------------
  # Lenovo X1 Carbon:
  #-------------------

  5d563aaaade24e3e9c790d6a1a5f982d)

    # External extends (1920x1080 no panning):
    xrandr | grep -q 'HDMI1 connected' && xrandr \
    --output LVDS1 --mode 1600x900 \
    --output HDMI1 --mode 1920x1080 --above LVDS1
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
