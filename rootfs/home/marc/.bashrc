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
alias sudo='A=`alias` sudo '
alias pacman='pacman --color auto'
alias startx='ssh-agent startx'
alias picocom='picocom -l /dev/pts/3'

#------------------------------------------------------------------------------
# PS1:
#------------------------------------------------------------------------------

PROMPT_COMMAND='RET=$?'
RET_VALUE='$(echo $RET)'
PS1="[$RET_VALUE] \[\e[1;32m\]\W \$(__git_ps1 \"(%s) \")>>\[\e[0m\] "

#------------------------------------------------------------------------------
# Git-prompt:
#------------------------------------------------------------------------------

[[ -f ~/.git-prompt.sh ]] && source ~/.git-prompt.sh

#------------------------------------------------------------------------------
# Tabbed ssh sessions:
#------------------------------------------------------------------------------

if [[ $TERM == 'rxvt-unicode-256color' ]]; then

  function tssh {
    printf "\033]777;tabbedex;set_tab_name;$1\007"
    ssh $1
    printf "\033]777;tabbedex;set_tab_name;\007"
  }

  function wrap {
    [[ "$BASH_COMMAND" == "$PROMPT_COMMAND" ]] && return
    CMD=`history | tail -n1 | sed 's/^[ 0-9]*//'`
    [[ "$CMD" == "$COMMANDLINE" || "$CMD" == "" ]] && return
    printf "\033]777;tabbedex;set_cmd;$CMD\007"
    export COMMANDLINE=$CMD
  }

  alias ssh='tssh'
  trap 'wrap' DEBUG

fi

#------------------------------------------------------------------------------
# Exports:
#------------------------------------------------------------------------------

export VISUAL=`which vim`
export EDITOR=`which vi`
export PATH="$PATH:$HOME/bin"
