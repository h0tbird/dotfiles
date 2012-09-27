#!/bin/sh

#----------
# Globals:
#----------

BASEDIR="/etc/.dotfiles/rootfs"
FILES=`find $BASEDIR -type f | cut -b 23-`

#------------
# Functions:
#------------

. /etc/rc.d/functions

function exists() {
    stat_busy $1; [ -f "$1" ] && return 0 || return 1
}

function hardlinked() {
    [ "`stat -c %i $1`" == "`stat -c %i $2`" ] && (stat_done; return 0) || return 1
}

function equal() {
    [ "`md5sum $1 | awk '{print $1}'`" == "`md5sum $2 | awk '{print $1}'`" ] && (stat_done; return 0) || return 1
}

function backup() {
    cp $1 $1.origin
}

function couple() {
    mkdir -p `dirname $1`
    cp -alf $2 $1 2> /dev/null || cp -f $2 $1
    stat_done
}

#------------
# Main loop:
#------------

for i in $FILES; do

    SRC="/$i"
    DST="$BASEDIR/$i"

    if exists $SRC; then

        hardlinked $SRC $DST && continue
        equal $SRC $DST && continue
        backup $SRC
    fi

    couple $SRC $DST

done

[[ -d /home/marc ]] && chown -R marc:users /home/marc

#----------------------------------
# Ignore changes to tracked files:
#----------------------------------

# git update-index --assume-unchanged path/to/tracked/file
# git ls-files -v | grep -e "^[hsmrck]"
# git update-index --no-assume-unchanged path/to/tracked/file
