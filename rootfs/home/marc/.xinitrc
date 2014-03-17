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

ID=$(sleep 1; xrandr --verbose | grep MHz | sort | awk '{print $1$2$3}' | md5sum | cut -f1 -d' ')

case $ID in

  # VirtualBox Latitude E7440:
  'ec867d3dfa8050c8e04b0ebc8acb67d1') xrandr --output VBOX0 --mode 1366x768 ;;

  # VirtualBox DELL E2313H:
  '1f1319d611e213e8fe87366a90f97120') xrandr --output VBOX0 --mode 1920x1080 ;;

  # Lenovo X1 Carbon and DELL E2313H:
  '0aaae6473d8e10796a6f93a3d31b9153') xrandr --output LVDS1 --mode 1600x900 --output DP1 --mode 1920x1080 --above LVDS1 ;;

  # VirtualBox DELL work:
  '38329c8139c7d4ba5cefcd8ddaa5c85b') xrandr --output VBOX0 --mode 1680x1050 ;;

esac

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

list=(urxvtd statusbar xcmenu)

for app in "${list[@]}"; do
  check=$(ps -C "$app" -opid=)
  if [[ -z "$check" ]]; then
    case "$app" in
      urxvtd) urxvtd -q -o -f ;;
      statusbar) statusbar & ;;
      xcmenu) xcmenu --daemon --primary --clipboard ;;
    esac
  fi
done

#---------------
# Start the WM:
#---------------

exec dwm
