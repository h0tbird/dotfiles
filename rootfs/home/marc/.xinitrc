#!/bin/sh

#---------------------------------------------------------
# Source xinitrc.d scripts:
#---------------------------------------------------------

if [ -d /etc/X11/xinit/xinitrc.d ]; then
  for f in /etc/X11/xinit/xinitrc.d/*; do
    [ -x "$f" ] && . "$f"
  done
fi

#---------------------
# Setup dual monitor:
#---------------------

xrandr | grep 'DP1 connected' && xrandr --output LVDS1 --mode 1600x900 --output DP1 --mode 1920x1080 --above LVDS1 &

#-------------------
# Load .Xresources:
#-------------------

[[ -f $HOME/.Xresources ]] && xrdb -merge $HOME/.Xresources

#------------------
# Add fonts paths:
#------------------

xset fp default
[[ -d $HOME/.fonts ]] && xset +fp $HOME/.fonts
xset fp rehash

#--------------------------------------------------------
# Start apps in background (only if not already running)
#--------------------------------------------------------

list=(urxvtd statusbar)

for app in "${list[@]}"; do
  check=$(ps -C "$app" -opid=)
  if [[ -z "$check" ]]; then
    case "$app" in
      urxvtd) urxvtd -q -o -f ;;
      statusbar) statusbar & ;;
    esac
  fi
done

#---------------
# Start the WM:
#---------------

exec dwm
