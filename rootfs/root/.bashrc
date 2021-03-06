# ~/.bashrc

#------------------------------------------------------------------------------
# If not running interactively, don't do anything:
#------------------------------------------------------------------------------

[[ $- != *i* ]] && return

#------------------------------------------------------------------------------
# Aliases:
#------------------------------------------------------------------------------

alias ls='ls -hF --color=auto --group-directories-first'
alias l='ls -l'
alias ll='ls -la'
alias grep='grep --color=auto'

#------------------------------------------------------------------------------
# PS1:
#------------------------------------------------------------------------------

PROMPT_COMMAND='RET=$?;'
RET_VALUE='$(echo $RET)'
PS1="[$RET_VALUE] \[\e[1;33m\]\W >>\[\e[0m\] "

#------------------------------------------------------------------------------
# Exports:
#------------------------------------------------------------------------------

export VISUAL=`which vim`
export EDITOR=`which vi`
export PATH="$PATH:$HOME/bin"
