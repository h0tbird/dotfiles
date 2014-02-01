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
alias picocom='picocom -l /dev/pts/4'

#------------------------------------------------------------------------------
# PS1:
#------------------------------------------------------------------------------

xdp="\033[0;35m"; dp="\[${xdp}\]" # Dark Purple
xdg="\033[1;30m"; dg="\[${xdg}\]" # Dark Gray
xlw="\033[1;37m"; lw="\[${xlw}\]" # Light White
xlg="\033[1;32m"; lg="\[${xlg}\]" # Light Green
xdb="\033[0;34m"; db="\[${xdb}\]" # Dark Blue
xlr="\033[1;31m"; lr="\[${xlr}\]" # Light Red
xnc="\033[0m";    nc="\[${xnc}\]" # No Colour

PROMPT_DIRTRIM=3
PROMPT_COMMAND='R=$?'
RET='$(echo $R)'
PS1="${dp}[${dg}${RET}${dp}] ${lw}\w ${lg}\$(__git_ps1 \"(%s) \")${db}>> ${nc}"

#------------------------------------------------------------------------------
# Git-prompt:
#------------------------------------------------------------------------------

GIT_PS1_SHOWDIRTYSTATE=true
[[ -f ~/.git-prompt.sh ]] && source ~/.git-prompt.sh

#------------------------------------------------------------------------------
# Tabbed helper functions:
#------------------------------------------------------------------------------

if [[ $TERM == 'rxvt-unicode-256color' ]]; then

  # Wrapper around ssh to set the current tab title:
  function tssh {
    printf "\033]777;tabbedex;set_tab_name;$1\007"
    ssh $@
    printf "\033]777;tabbedex;set_tab_name;\007"
  }

  # Keep track of the last executed command:
  function wrap {
    [[ "$BASH_COMMAND" == "$PROMPT_COMMAND" ]] && return
    CMD=`history | tail -n1 | sed 's/^[ 0-9]*//;s/%/%%/g'`
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
export EDITOR=`which vim`
export PATH="$PATH:$HOME/bin"
