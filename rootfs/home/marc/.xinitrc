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
# VMWare guest services:
#------------------------------------------------------------------------------

[ -x /usr/sbin/vmware-user ] && /usr/sbin/vmware-user

#------------------------------------------------------------------------------
# Load .Xresources:
#------------------------------------------------------------------------------

[ -f ${HOME}/.Xresources ] && xrdb -merge ${HOME}/.Xresources

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

    # Keyboard layout:
    setxkbmap -model pc104 -layout us

    # External extends (1920x1080 no panning):
    xrandr | grep -q 'HDMI1 connected' \
    && xrandr --dpi 138 \
    --output LVDS1 --mode 1600x900 \
    --output HDMI1 --mode 1920x1080 --above LVDS1
    ;;

  #---------
  # vmware:
  #---------

  b422c3b66842496db5307e940c28767a)

    # Keyboard layout:
    setxkbmap -model pc104 -layout us

    # Map middle mouse button:
    xmodmap -e "keycode 134 = Pointer_Button2"
    xkbset m

    # Host is LG 3840x2160
    xrandr | grep -q Virtual2 && xrandr \
    --output Virtual1 --below Virtual2 --mode 1680x1050 --output Virtual2 \
    --mode 3840x2160 || xrandr --output Virtual1 --mode 3840x2160
    ;;

esac

#------------------------------------------------------------------------------
# Start the WM:
#------------------------------------------------------------------------------

exec i3
