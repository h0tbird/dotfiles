#!/bin/sh

BASEDIR="/etc/.dotfiles/rootfs"

for i in `find ${BASEDIR} -type f | cut -b 23-`; do
    cp -alf ${BASEDIR}/${i} /${i} 2> /dev/null || cp -f ${BASEDIR}/${i} /${i}
done
