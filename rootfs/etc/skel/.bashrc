#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls -hF --color=auto'
alias l='ls -l'
alias ll='ls -la'

PS1='[\u@\h \W]\$ '
export VISUAL=`which vim`
export EDITOR=`which vi`
