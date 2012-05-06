#!/bin/sh

BASE="/etc/.dotfiles"

# /root
FILE[0]="root/.bash_profile"
FILE[1]="root/.bashrc"
for i in ${FILE[@]}; do [ ! -f /${i} ] && cp ${BASE}/${i} /${i}; done

# /etc
FILE[0]="etc/vimrc"
FILE[1]="etc/pacman.conf"
FILE[2]="etc/sudoers"
for i in ${FILE[@]}; do [ ! /${i} -ef ${BASE}/${i} ] && rm -f /${i} && ln ${BASE}/${i} /${i}; done

# /etc/skel
DIR[0]="etc/skel/.config"
DIR[1]="etc/skel/.config/awesome"
for i in ${DIR[@]}; do [ ! -d /${i} ] && mkdir /${i} && chmod 0700 /${i}; done

FILE[0]="etc/skel/.bash_profile"
FILE[1]="etc/skel/.bashrc"
FILE[2]="etc/skel/.xinitrc"
FILE[3]="etc/skel/.config/awesome/rc.lua"
for i in ${FILE[@]}; do [ ! /${i} -ef ${BASE}/${i} ] && rm -f /${i} && ln ${BASE}/${i} /${i}; done
