#!/bin/sh

#---------------------------------------------------------
# Source xinitrc.d scripts:
#---------------------------------------------------------

if [ -d /etc/X11/xinit/xinitrc.d ]; then
    for f in /etc/X11/xinit/xinitrc.d/*; do
        [ -x "$f" ] && . "$f"
    done
    unset f
fi

#-----------------
# Set background:
#-----------------

sh $HOME/.fehbg &

#-------------------
# Load .Xresources:
#-------------------

[[ -f $HOME/.Xresources ]] && xrdb -merge $HOME/.Xresources

#---------------------------
# Setup the keyring daemon:
#---------------------------

source /etc/X11/xinit/xinitrc.d/30-dbus
eval $(/usr/bin/gnome-keyring-daemon --start --components=gpg,pkcs11,secrets,ssh)
export GNOME_KEYRING_CONTROL GNOME_KEYRING_PID GPG_AGENT_INFO SSH_AUTH_SOCK

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
            dropbox) dropboxd & ;;
            mpd) mpd ;;
            urxvtd) urxvtd -q -o -f ;;
            statusbar) statusbar & ;;
        esac
    fi
done

#---------------
# Start the WM:
#---------------

exec dwm
