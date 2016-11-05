#tmuxify {{{
if [[ ! -n $TMUX ]]; then
  tmux
  exit
fi
# }}}
# options {{{
setopt correct
setopt interactivecomments
setopt histignorealldups
setopt nohup
# }}}
# autoload {{{
autoload -Uz compinit && compinit
autoload -Uz colors && colors
# completion {{{
zstyle ':completion:*' auto-description 'specify: %d'
zstyle ':completion:*' completer _expand _complete _correct _approximate
zstyle ':completion:*' format 'Completing %d'
zstyle ':completion:*' group-name ''
zstyle ':completion:*' menu select=2 eval "$(dircolors -b)"
zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*' list-colors ''
zstyle ':completion:*' list-prompt %SAt %p: Hit TAB for more, or the character to insert%s
zstyle ':completion:*' matcher-list '' 'm:{a-z}={A-Z}' 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=* l:|=*'
zstyle ':completion:*' menu select=long
zstyle ':completion:*' select-prompt %SScrolling active: current selection at %p%s
zstyle ':completion:*' use-compctl false
zstyle ':completion:*' verbose true
zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#)*=0=01;31'
zstyle ':completion:*:kill:*' command 'ps -u $USER -o pid,%cpu,tty,cputime,cmd'
# }}}
# }}}
# base variables {{{
PS1="%{$fg[magenta]%}[%1~]%{$reset_color%} "
# }}}
# path {{{
export PATH="$PATH:$HOME/bin:$HOME/.local/bin"
# }}}
# aliases {{{
alias ls="ls --color=auto -h"
alias mv="mv -v"
alias cp="cp -rv"
alias reload="source ~/.zshrc"
# }}}
# functions {{{
# start thing detached, in background
bk() { nohup $* >/dev/null 2>&1 & }

# start screensaver instantly
# if xscreensaver is not running, start it
svr() {
  [[ ! $(pgrep xscreensaver) ]] && bk xscreensaver -no-splash
  xscreensaver-command -lock
}
# }}}
# exports {{{
export GOPATH="$HOME/dev/go"
export EDITOR="nvim"
export PREFIX="$HOME/.local"
export SSH_AUTH_SOCK="$XDG_RUNTIME_DIR/ssh-agent.socket"
export PAGER="less"
# }}}
