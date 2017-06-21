# keychain {{{
if [[ ! -n $SSH_CONNECTION ]]; then
  if ! pgrep -u "$USER" ssh-agent > /dev/null; then
    ssh-agent | head -n 2 > ~/.shag
    eval "$(<~/.shag)"
    while true; do
      ssh-add ~/.ssh/id_rsa
      if [[ "$?" == "0" ]]; then
        break
      fi
    done
  fi
  if [[ "$SSH_AGENT_PID" == "" ]]; then
    eval "$(<~/.shag)"
  fi
fi
# }}}

[[ -f ~/.zshtokens ]] && source ~/.zshtokens

# completion
autoload -Uz compinit
compinit
zstyle ':completion:*' menu select
zstyle ':completion:*' rehash true
setopt complete_aliases

# history
HISTFILE=~/.zsh_history
HISTSIZE=30000
SAVEHIST=30000
setopt append_history
setopt extended_history

if [[ -x /usr/bin/hub ]]; then
  alias git="hub"
fi

export GOPATH="$HOME/go"

NPM_PACKAGES="${HOME}/.npm-packages"

path=(
  $NPM_PACKAGES/bin
  $PREFIX/bin
  $HOME/subl
  $GOPATH/bin
  $HOME/.local/bin
  $HOME/bin
  $HOME/.cargo/bin
  $HOME/.gem/ruby/2.4.0/bin
  $HOME/.yarn/bin
  /usr/bin/site_perl
  /usr/bin/vendor_perl
  /usr/bin/core_perl
  /usr/local/sbin
  /usr/local/bin
  /usr/bin
  /bin
  /sbin
  /usr/lib/jvm/default/bin
)

if [[ -n $SSH_CONNECTION ]]; then
  export EDITOR="vim"
else
  export EDITOR="nvim"
fi

alias g="git"
alias cp="cp -r"
alias ls="ls --color=auto -hF"
alias reload="source ~/.zshrc"
alias e="$EDITOR"
alias se="sudo -E $EDITOR"
alias lck="xscreensaver-command -lock"
alias space="du -h --max-depth 1"
alias glo="glol"
alias gl="glo"
alias grs="git reset"
alias sub="sublime_text"
alias py="python"
av() {
  source ~/venvs/$1/bin/activate
  if [[ "$?" == "0" ]]; then
    echo "✔ Activated \`$1'."
  else
    echo "✘ Could not activate..."
  fi
}
alias deav="deactivate"

ed() {
  lunch "~/bin/ed $*"
}

# launch something in detatched urxvtc
lunch() {
  (nohup urxvtc -e zsh -c "$*" >/dev/null 2>&1 &)
}

# high quality gif creation
hqgif() {
  palette="/tmp/gif_palette.png"
  filters="fps=10"
  ffmpeg -v warning -i $1 -vf "$filters,palettegen" -y $palette
  ffmpeg -v warning -i $1 -i $palette -lavfi "$filters [x]; [x][1:v] paletteuse" -y $2
}

# run some command in the background
bk() {
  (nohup $* >/dev/null 2>&1 &)
}

export PS1="%4~%% "

# pyenv
export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
