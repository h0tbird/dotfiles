#!/bin/sh

BASEDIR="/etc/.dotfiles/rootfs"

for i in `find ${BASEDIR} -type f | cut -b 23-`; do
    mkdir -p `dirname /${i}`
    cp -alf ${BASEDIR}/${i} /${i} 2> /dev/null || cp -f ${BASEDIR}/${i} /${i}
done

#----------------------------------
# Ignore changes to tracked files:
#----------------------------------

# git update-index --assume-unchanged path/to/tracked/file
# git ls-files -v | grep -e "^[hsmrck]"
# git update-index --no-assume-unchanged path/to/tracked/file
