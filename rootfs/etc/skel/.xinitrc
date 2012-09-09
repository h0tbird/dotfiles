#!/bin/sh

#--------------------------------------------------------
# Executed by startx (run your window manager from here)
#--------------------------------------------------------

if [ -d /etc/X11/xinit/xinitrc.d ]; then
  for f in /etc/X11/xinit/xinitrc.d/*; do
    [ -x "$f" ] && . "$f"
  done
  unset f
fi

#---------------------
# Set the resolution:
#---------------------

xrandr --newmode "1600x900_60.00"  118.25  1600 1696 1856 2112  900 903 908 934 -hsync +vsync
xrandr --addmode VBOX0 1600x900_60.00
xrandr --output VBOX0 --mode 1600x900_60.00

#--------------------------------
# Window Manager of your choice:
#--------------------------------

[[ -f ~/.Xresources ]] && xrdb -merge ~/.Xresources
urxvtd -q -o -f
xcompmgr &
exec awesome
