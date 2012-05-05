#!/bin/sh

BASE="/etc/.dotfiles"
FILE="root/.bash_profile";     [ ! -f /${FILE} ] && cp ${BASE}/${FILE} /${FILE}
FILE="root/.bashrc";           [ ! -f /${FILE} ] && cp ${BASE}/${FILE} /${FILE}
FILE="etc/skel/.bash_profile"; [ ! -h /${FILE} ] && [ -f /${FILE} ] && rm -f /${FILE} && ln -s ${BASE}/${FILE} /${FILE}
FILE="etc/skel/.bashrc";       [ ! -h /${FILE} ] && [ -f /${FILE} ] && rm -f /${FILE} && ln -s ${BASE}/${FILE} /${FILE}
FILE="etc/vimrc";              [ ! -h /${FILE} ] && [ -f /${FILE} ] && rm -f /${FILE} && ln -s ${BASE}/${FILE} /${FILE}
FILE="etc/pacman.conf";        [ ! -h /${FILE} ] && [ -f /${FILE} ] && rm -f /${FILE} && ln -s ${BASE}/${FILE} /${FILE}
