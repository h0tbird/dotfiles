#------------------------------------------------------------------------------
# Setting up history:
#------------------------------------------------------------------------------

HISTFILE=~/.histfile
HISTSIZE=1000
SAVEHIST=1000

#------------------------------------------------------------------------------
# Specifying options:
#------------------------------------------------------------------------------

setopt appendhistory autocd beep extendedglob nomatch notify

#------------------------------------------------------------------------------
# Aliasing:
#------------------------------------------------------------------------------

# General:
alias ls='ls -hF --color=auto --group-directories-first'
alias l='ls -l'
alias ll='ls -la'
alias grep='grep --color=auto'

# Docker:
alias dim='docker images'
alias dps='docker ps'
alias dki='docker run -i -t -P'
alias drm='docker rm $(docker ps -qa)'
alias dip="docker inspect --format '{{ .NetworkSettings.IPAddress }}'"
alias drmi='docker rmi $(docker images | grep "^<none>" | awk "{print $3}")';
alias dkb='docker build --rm -t ${PWD##*/} .'

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
# Set and export LS_COLORS:
#------------------------------------------------------------------------------

eval "$(dircolors -b)"

# The following lines were added by compinstall
zstyle :compinstall filename '/home/marc/.zshrc'

#------------------------------------------------------------------------------
# Advanced tab-completion:
#------------------------------------------------------------------------------

autoload -Uz compinit && compinit
zstyle ':completion:*' menu select
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}

#------------------------------------------------------------------------------
# Key bindings:
#------------------------------------------------------------------------------

bindkey '^[[1;5C' emacs-forward-word
bindkey '^[[1;5D' emacs-backward-word
bindkey -v
bindkey '^P' up-history
bindkey '^N' down-history
bindkey '^?' backward-delete-char
bindkey '^h' backward-delete-char
bindkey '^w' backward-kill-word
bindkey '^r' history-incremental-search-backward

function zle-line-init zle-keymap-select {
    VIM_PROMPT="%{$fg_bold[yellow]%} [% NORMAL]%  %{$reset_color%}"
    RPS1="${${KEYMAP/vicmd/$VIM_PROMPT}/(main|viins)/} $EPS1"
    zle reset-prompt
}

zle -N zle-line-init
zle -N zle-keymap-select
export KEYTIMEOUT=1
