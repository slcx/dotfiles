# -- omz

export ZSH=/Users/ryant/.oh-my-zsh
ZSH_THEME="robbyrussell"

# --- omz settings
CASE_SENSITIVE="false"
HYPHEN_INSENSITIVE="false"
DISABLE_AUTO_UPDATE="false"
export UPDATE_ZSH_DAYS=10
DISABLE_LS_COLORS="false"
DISABLE_AUTO_TITLE="true"
ENABLE_CORRECTION="true"
COMPLETION_WAITING_DOTS="true"

plugins=(git)

source $ZSH/oh-my-zsh.sh

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

# --- useful aliases
alias reload="source ~/.zshrc"
alias serve="python3 -m http.server"
alias ls="ls -hGp"
alias e="$EDITOR"
alias public_ip="curl https://ifconfig.co"
function local_ip() {
  ifconfig | grep 'inet ' | awk '{ print $2 }'
}
function pva() {
  if [[ ! -d "$HOME/Code/Virtualenvs/$1" ]]; then
    echo "pva: no such virtualenv"
    return
  fi
  source "$HOME/Code/Virtualenvs/$1/bin/activate"
}
alias dva="deactivate"
function rmux() {
  ssh "$1" -t 'tmux a'
}
function gsyn() {
  git fetch --all
  git reset --hard $1/master
}
alias sherlock="mdfind -name"
alias svg2png="rsvg-convert -h 1000"

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
function gl() {
  git log --graph --oneline --pretty='format:%C(yellow)%h%Creset %s %C(bold)(%an, %cr)%Creset'
}
alias grm="git rm"
alias gb="git branch"
alias ga="git add"
function gsu() {
  git remote add origin "git@github.com:slice/$1.git"
}
alias gcl="git clone"
[[ -x "/usr/local/bin/hub" ]] && alias git="hub"

# --- path
export PATH="$GOPATH/bin:$HOME/.yarn/bin:$HOME/.npm/bin:$PATH"

# -- post-scripts
. "$HOME/Code/Lib/z/z.sh"
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh


