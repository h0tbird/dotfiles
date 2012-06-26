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

#--------------------------------
# Window Manager of your choice:
#--------------------------------

xcompmgr &
urxvtd -q -o -f
exec awesome
