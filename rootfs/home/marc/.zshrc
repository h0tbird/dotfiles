#------------------------------------------------------------------------------
# '.zshrc' is sourced in interactive shells. It should contain commands to set
# up aliases, functions, options, key bindings, etc.
#------------------------------------------------------------------------------

#------------------------------------------------------------------------------
# Setting up history:
#------------------------------------------------------------------------------

HISTFILE=~/.histfile
HISTSIZE=1000
SAVEHIST=1000

#------------------------------------------------------------------------------
# Specifying options:
#------------------------------------------------------------------------------

setopt append_history
setopt extended_history
setopt hist_find_no_dups
setopt hist_ignore_dups
setopt hist_verify
setopt autocd
setopt beep
setopt extended_glob
setopt nomatch
setopt notify

#------------------------------------------------------------------------------
# Autoload functions:
#------------------------------------------------------------------------------

autoload -U compinit && compinit
autoload -U colors && colors
autoload -U add-zsh-hook
autoload -U select-word-style

#------------------------------------------------------------------------------
# Aliasing:
#------------------------------------------------------------------------------

# General:
alias ls='ls -hF --color=auto --group-directories-first'
alias l='ls -l'
alias ll='ls -la'
alias grep='grep --color=auto'
alias wanip='dig +short myip.opendns.com @resolver1.opendns.com'

# Docker:
alias dim='docker images'
alias dps='docker ps'
alias dki='docker run -i -t -P'
alias drm='docker rm -v $(docker ps -qaf "status=exited")'
alias dip="docker inspect --format '{{ .NetworkSettings.IPAddress }}'"
alias drmi='docker rmi $(docker images -qf "dangling=true")'
alias dkb='docker build --rm -t ${PWD##*/} .'

#------------------------------------------------------------------------------
# urxvt-tabbedex:
#------------------------------------------------------------------------------

if [[ $TERM == 'rxvt-unicode-256color' ]]; then

  #--------------------
  # Set the tab title:
  #--------------------

  function ssh {
    printf "\033]777;tabbedex;set_tab_name;${@: -1}\007"
    /usr/sbin/ssh $@
    printf "\033]777;tabbedex;set_tab_name;\007"
  }

  #--------------------------
  # Set cmd for cloned tabs:
  #--------------------------

  function set_cmd_hook {
    printf "\033]777;tabbedex;set_cmd;$1\007"
  }

  add-zsh-hook preexec set_cmd_hook

fi

#------------------------------------------------------------------------------
# PS1:
#------------------------------------------------------------------------------

dp="%{[38;5;13m%}"  # Deep purple
lg="%{[38;5;35m%}"  # Light green
lr="%{[38;5;01m%}"  # Light red
bw="%{[38;5;231m%}" # Bright white
nc="%{[00m%}"       # No color

setopt prompt_subst
source ~/.zsh/git-prompt/zshrc.sh
precmd() { R=$?; [ $R -eq 0 ] && RET="${lg}${R}" || RET="${lr}${R}" }
PROMPT='${dp}[${RET}${dp}]${bw} %~ ${nc}$(git_super_status)${dp}>> ${nc}'

#------------------------------------------------------------------------------
# Advanced tab-completion:
#------------------------------------------------------------------------------

eval "$(dircolors -b)"

# menu
zstyle ':completion:*' menu select
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}

# partial match
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'

# kill
zstyle ':completion:*:*:*:*:processes' command "ps -u $USER -o pid,user,comm -w -w"
zstyle ':completion:*:*:kill:*:processes' list-colors "=(#b) #([0-9]#) ([0-9a-z-]#)*=$color[green]=0=$color[black]"
zstyle ':completion:*:*:kill:*' force-list always

#------------------------------------------------------------------------------
# Google Cloud SDK:
#------------------------------------------------------------------------------

[ -d /opt/google-cloud-sdk ] && {
  source /opt/google-cloud-sdk/path.zsh.inc
  source /opt/google-cloud-sdk/completion.zsh.inc
}

#------------------------------------------------------------------------------
# Tab-completion:
#------------------------------------------------------------------------------

source <(katoctl --completion-script-zsh)
source <(kubectl completion zsh)
source <(helm completion zsh)

#------------------------------------------------------------------------------
# AWS cli completion:
#------------------------------------------------------------------------------

[ -f /usr/sbin/aws_zsh_completer.sh ] && {
  source /usr/sbin/aws_zsh_completer.sh
}

#------------------------------------------------------------------------------
# Define word boundary:
#------------------------------------------------------------------------------

select-word-style bash
export WORDCHARS="*?_-[]~=/&;!#$%^(){}<>"

#------------------------------------------------------------------------------
# Key bindings:
#------------------------------------------------------------------------------

bindkey -e
bindkey '^[[1;5C' emacs-forward-word
bindkey '^[[1;5D' emacs-backward-word
bindkey '^P' up-history
bindkey '^N' down-history
bindkey '^?' backward-delete-char
bindkey '^h' backward-delete-char
bindkey '^w' backward-kill-word
bindkey '^r' history-incremental-search-backward
