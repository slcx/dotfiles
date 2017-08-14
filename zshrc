#!/usr/bin/env zsh

# --- oh-my-zsh-related exports
export ZSH=/Users/ryant/.oh-my-zsh
export ZSH_CUSTOM=/Users/ryant/.oh-my-zsh-custom
export ZSH_THEME="slice"
export CASE_SENSITIVE="true"
export HYPHEN_INSENSITIVE="true"
export UPDATE_ZSH_DAYS=13
export COMPLETION_WAITING_DOTS="true"
export DISABLE_UNTRACKED_FILES_DIRTY="true"

# --- regular exports
export LANG=en_US.UTF-8
export ARCHFLAGS="-arch x86_64"
export SSH_KEY_PATH="$HOME/.ssh/rsa_id"
export MAGICK_HOME="/usr/local/opt/imagemagick@6/"
export WORKON_HOME="$HOME/Code/Virtualenvs"
export VIRTUALENVWRAPPER_PYTHON="/usr/local/bin/python3"
export EDITOR="subl -w"
export NODE_PATH="/usr/local/lib/node_modules"
export NVM_DIR="$HOME/.nvm"

# --- oh-my-zsh startup
export plugins=(python git nvm)
source $ZSH/oh-my-zsh.sh

# --- useful aliases
alias reload="source ~/.zshrc"
alias serve="python3 -m http.server"
alias public-ip="curl https://ifconfig.co"
function local-ip() {
  ifconfig | grep 'inet ' | awk '{ print $2 }'
}

# --- post-scripts
if brew command command-not-found-init > /dev/null 2>&1; then eval "$(brew command-not-found-init)"; fi

# nvm
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
