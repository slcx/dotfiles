#!/usr/bin/env zsh

# -- history
setopt inc_append_history
setopt extended_history
HISTFILE="$HOME/.zsh_history"
HISTSIZE=10000000
SAVEHIST=10000000

# -- ps1
autoload -U colors && colors
setopt PROMPT_SUBST
PROMPT='%{$fg[magenta]%}%3~%{$reset_color%} ❯ '

# -- regular exports
export LANG=en_US.UTF-8
export ARCHFLAGS="-arch x86_64"
export SSH_KEY_PATH="$HOME/.ssh/rsa_id"
export MAGICK_HOME="/usr/local/opt/imagemagick@6/"
export WORKON_HOME="$HOME/Code/Virtualenvs"
export VIRTUALENVWRAPPER_PYTHON="/usr/local/bin/python3"
export EDITOR="nvim"
export NODE_PATH="/usr/local/lib/node_modules"
export NVM_DIR="$HOME/.nvm"
export GOPATH="$HOME/Code/Go"

# -- useful aliases
alias reload="source ~/.zshrc && clear; echo reloaded!"
alias serve="python3 -m http.server"
alias ls="ls -hGp"
alias e="$EDITOR"
alias dva="deactivate"
alias sherlock="mdfind -name"
alias svg2png="rsvg-convert -h 1000"
alias usage="du -h -d 1 ."

# -- functions
function pva() {
  if [[ ! -d "$HOME/Code/Virtualenvs/$1" ]]; then
    echo "pva: no such virtualenv"
    return
  fi
  source "$HOME/Code/Virtualenvs/$1/bin/activate"
}

function gsyn() {
  git fetch --all
  git reset --hard "$1/master"
}

function rmux() {
  ssh "$1" -t 'tmux a'
}

# -- tool aliases
alias dkc="docker-compose"
alias dk="docker"
alias br="brew"
alias gc="git commit -v"
alias gr="git remote"
alias gd="git diff"
alias gst="git status -s"
alias gp="git push"
alias grh="git reset HEAD"
alias gs="git show"
alias gl="git log --graph --oneline --pretty='format:%C(yellow)%h%Creset %s %C(bold)(%an, %cr)%Creset'"
alias grm="git rm"
alias gb="git branch"
alias ga="git add"
function gsu() {
  if [[ ! "$1" ]]; then
    echo "err: provide repo name"
    return
  fi
  git remote add origin "git@github.com:slice/$1.git"
}
alias gcl="git clone"
[[ -x "/usr/local/bin/hub" ]] && alias git="hub"

# --- path
export PATH="$GOPATH/bin:$HOME/.yarn/bin:$HOME/.npm/bin:$PATH"

# -- post-scripts
[[ -f ~/Code/Lib/z/z.sh ]] && source "$HOME/Code/Lib/z/z.sh"
[[ -f ~/.fzf.zsh ]] && source ~/.fzf.zsh


