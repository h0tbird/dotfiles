#!/bin/sh

BASE="/etc/.dotfiles"
FILE="root/.bash_profile";     [ ! -f /${FILE} ] && cp ${BASE}/${FILE} /${FILE}
FILE="root/.bashrc";           [ ! -f /${FILE} ] && cp ${BASE}/${FILE} /${FILE}
FILE="etc/skel/.bash_profile"; [ ! /${FILE} -ef ${BASE}/${FILE} -a -f /${FILE} ] && rm -f /${FILE} && ln ${BASE}/${FILE} /${FILE}
FILE="etc/skel/.bashrc";       [ ! /${FILE} -ef ${BASE}/${FILE} -a -f /${FILE} ] && rm -f /${FILE} && ln ${BASE}/${FILE} /${FILE}
FILE="etc/skel/.xinitrc";      [ ! /${FILE} -ef ${BASE}/${FILE} -a -f /${FILE} ] && rm -f /${FILE} && ln ${BASE}/${FILE} /${FILE}
FILE="etc/vimrc";              [ ! /${FILE} -ef ${BASE}/${FILE} -a -f /${FILE} ] && rm -f /${FILE} && ln ${BASE}/${FILE} /${FILE}
FILE="etc/pacman.conf";        [ ! /${FILE} -ef ${BASE}/${FILE} -a -f /${FILE} ] && rm -f /${FILE} && ln ${BASE}/${FILE} /${FILE}
FILE="etc/sudoers";            [ ! /${FILE} -ef ${BASE}/${FILE} -a -f /${FILE} ] && rm -f /${FILE} && ln ${BASE}/${FILE} /${FILE}
