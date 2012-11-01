#!/bin/sh

#----------
# Globals:
#----------

BASEDIR="/etc/.dotfiles/rootfs"
FILES=`find $BASEDIR -type f | cut -b 23-`

#-------------------
# Helper functions:
#-------------------

C_CLEAR=$(tput sgr0)
C_MAIN=${C_CLEAR}$(tput bold)
C_OTHER=${C_MAIN}$(tput setaf 4)
C_BUSY=${C_CLEAR}$(tput setaf 6)
DEL_TEXT="\e[$(( $(( $(tput cols) - 13 )) + 4 ))G"

deltext() {
    printf "${DEL_TEXT}"
}

stat_busy() {
    printf "${C_OTHER}:: ${C_MAIN}${1}${C_CLEAR} "
    printf "\e[s"
    deltext
    printf "   ${C_OTHER}[${C_BUSY}BUSY${C_OTHER}]${C_CLEAR} "
}

stat_done() {
    deltext
    printf "   ${C_OTHER}[${C_MAIN}DONE${C_OTHER}]${C_CLEAR} \n"
}

#------------
# Functions:
#------------

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
