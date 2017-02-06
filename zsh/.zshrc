# keychain {{{
eval $(keychain --eval --quiet id_rsa)
[[ -f ~/.zshtokens ]] && source ~/.zshtokens
# }}}
# early aliases {{{
if [[ -x /usr/bin/hub ]]; then
  alias git="hub"
fi
# }}}
# oh my zsh {{{
export ZSH=/home/ch/.oh-my-zsh
export UPDATE_ZSH_DAYS=5
HYPHEN_INSENSITIVE="true"
COMPLETION_WAITING_DOTS="true"
DISABLE_UNTRACKED_FILES_DIRTY="true"
plugins=(git)
source $ZSH/oh-my-zsh.sh
PS1="%3~%% "
# }}}
# path {{{
path=(
  # danger zone
  ./node_modules/.bin

  # ~/.local bin files
  $HOME/.local/bin

  # binscripts
  $HOME/.bin

  # rust
  $HOME/.cargo/bin

  # ruby
  $HOME/.gem/ruby/2.4.0/bin

  # yarn
  $HOME/.yarn/bin

  # perl
  /usr/bin/site_perl
  /usr/bin/vendor_perl
  /usr/bin/core_perl

  # sane bin
  /usr/local/sbin
  /usr/local/bin
  /usr/bin
  /bin
  /sbin
  /usr/lib/jvm/default/bin
)
# }}}
# ssh {{{
if [[ -n $SSH_CONNECTION ]]; then
  export EDITOR="vim"
else
  export EDITOR="nvim"
fi
# }}}
# env {{{
export GOPATH="$HOME/dev/go"
export LS_COLORS="or=30;41:mi=30;41:di=34:ln=1;35:so=30;42:pi=33:ex=32:bd=30;46:cd=30;43:su=30;41:sg=30;46:tw=30;42:ow=30;43"
# }}}
# aliases {{{
alias cp="cp -r"
alias ls="ls --color=auto -hF"
alias reload="source ~/.zshrc"
alias evc="e ~/.config/nvim/init.vim"
alias e="$EDITOR"
# }}}
# functions {{{
ed() {
  lunch "~/.bin/ed $*"
}

lunch() {
  (nohup urxvtc -e zsh -i -c "$*" >/dev/null 2>&1 &)
}

hqgif() {
  palette="/tmp/gif_palette.png"
  filters="fps=10,scale=400:-1:flags=lanczos"
  ffmpeg -v warning -i $1 -vf "$filters,palettegen" -y $palette
  ffmpeg -v warning -i $1 -i $palette -lavfi "$filters [x]; [x][1:v] paletteuse" -y $2
}

bk() {
  (nohup $* >/dev/null 2>&1 &)
}
# }}}
# antigen, plugins n stuff {{{
# nvm lazy load
export NVM_LAZY_LOAD=true

# load antigen
source ~/antigen/antigen.zsh

antigen use oh-my-zsh

antigen bundle zsh-users/zsh-syntax-highlighting
antigen bundle git
antigen bundle command-not-found
antigen bundle lukechilds/zsh-nvm
antigen theme cypher

antigen apply
# }}}
