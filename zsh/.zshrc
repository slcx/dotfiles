# keychain {{{
eval $(keychain --eval --quiet id_rsa)
[[ -f ~/.zshtokens ]] && source ~/.zshtokens
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
PS1="[%{$fg[magenta]%}%4~%{$reset_color%}] "
# }}}
# path {{{
export PATH="$PATH:$HOME/bin:$HOME/.local/bin:$HOME/.gem/ruby/2.3.0/bin:$HOME/.bin"
export PATH="$HOME/.luarocks/bin:$HOME/.pyenv/shims:./node_modules/.bin:$PATH:$HOME/.cargo/bin"
# }}}
# exports {{{
export GOPATH="$HOME/dev/go"
export EDITOR="nvim"
export PREFIX="$HOME/.local"
export PAGER="less"
# }}}
# aliases {{{
alias ls="ls --color=auto"
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

dkm-unset() { eval $(docker-machine env -u) }
dkm-env() { eval $(docker-machine env $1) }

e() {
  # call editor
  $EDITOR $*
}

ed() {
  nohup st -e $EDITOR $* >/dev/null 2>&1 &
}

ev() {
  pushd ~/.config/nvim
  ed ~/.config/nvim/init.vim
  popd
}

export WINEPREFIX=$HOME/wine32
export WINEARCH=win32

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
# opam {{{
. /home/cheesy/.opam/opam-init/init.zsh > /dev/null 2> /dev/null || true
# }}}
