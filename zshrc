HISTFILE="$HOME/.zsh_history"
HISTSIZE=10000000
SAVEHIST=10000000
setopt extended_history
setopt inc_append_history
setopt share_history
setopt hist_reduce_blanks

autoload -U compinit && compinit
zstyle ':completion:::::' completer _complete _approximate
zstyle ':completion:*:approximate:*' max-errors 2

export EDITOR='nvim'
export PS1='%4~ ❯ '
export GOPATH="$HOME/src/go"
export PATH="$PATH:$HOME/.npm/bin:/usr/local/opt/go/libexec/bin:/usr/local/bin/:$GOPATH/bin"

if [ -x /usr/local/bin/hub ]; then
  alias git='hub'
fi

alias br='brew'
alias gi='git init'
alias gc='git commit -v'
alias gco='git checkout'
alias gr='git remote'
alias gd='git diff'
alias gst='git status -s'
alias gp='git push'
alias gpl='git pull'
alias grh='git reset HEAD'
alias gs='git show'
alias gl="git log --graph --oneline --pretty='format:%C(yellow)%h%Creset %s %C(bold)(%an, %cr)%Creset'"
alias grm='git rm'
alias gb='git branch'
alias ga='git add'
alias gcl='git clone'
alias e="$EDITOR"
alias ls='ls -GFh'
alias ll='ls -l'
alias la='ls -al'
alias reload='source ~/.zshrc'
alias usage='du -h -d 1 .'
alias ydl='youtube-dl'
alias ydle='ydl --extract-audio'

# quickly move file to current directory, and create link from file
# in current dir to previous location
lqk() {
  if [ -n "$2" ]; then
    dest="$2"
  else
    dest=$(basename $1)
  fi
  mv -v "$1" "$dest"
  ln -vs "$(greadlink -f $dest)" "$1"
}
