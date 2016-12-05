# shag {{{
if ! pgrep -u $USER ssh-agent >/dev/null; then
  ssh-agent > ~/.shag
  eval $(<~/.shag) >/dev/null

  # reset $? to 1
  false

  while [ $? -ne 0 ]; do
    echo shag: hi there, please add your ssh key
    ssh-add ~/.ssh/id_rsa
  done
else
  eval $(<~/.shag) >/dev/null
fi
# }}}
# options {{{
setopt interactivecomments
setopt nohup
setopt hist_ignore_all_dups
setopt hist_ignore_dups
setopt hist_ignore_space
setopt inc_append_history
setopt no_hist_allow_clobber
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
# history {{{
SAVEHIST=10000
HISTFILE=~/.zsh_history
# }}}
# base variables {{{
PS1="%{$fg[magenta]%}%4~%{$reset_color%} > "
# }}}
# path {{{
export PATH="$PATH:$HOME/bin:$HOME/.local/bin:$HOME/.gem/ruby/2.3.0/bin"
export PATH="./node_modules/.bin:$PATH"
# }}}
# exports {{{
export GOPATH="$HOME/dev/go"
export EDITOR="nvim-qt"
export PREFIX="$HOME/.local"
export SSH_AUTH_SOCK="$XDG_RUNTIME_DIR/ssh-agent.socket"
export PAGER="less"
# }}}
# aliases {{{
alias ls="ls --color=auto -h"
alias mv="mv -v"
alias cp="cp -rv"
alias reload="source ~/.zshrc"
alias mi="TERM=xterm-256color micro"

if [ -x /usr/bin/hub ]; then
  alias git="hub"
fi
# }}}
# functions {{{
# start thing detached, in background
bk() { nohup $* >/dev/null 2>&1 & }

e() {
  # call editor
  nohup $EDITOR $* >/dev/null 2>&1 &
}

wine32() {
  WINEPREFIX=$HOME/wine32 WINEARCH=win32 wine $*
}

# start screensaver instantly
# if xscreensaver is not running, start it
svr() {
  [[ ! $(pgrep xscreensaver) ]] && bk xscreensaver -no-splash
  xscreensaver-command -lock
}

# restart panel
repanel() {
  pkill -x panel
  bk ~/.config/bspwm/panel
  if [ ! $(pidof -x sxhkd) ]; then
    bk sxhkd
  fi
}
# }}}
