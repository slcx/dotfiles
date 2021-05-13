# slice's ~/.zshrc
# (^_^)>

HISTFILE="$HOME/.zsh_history"
HISTSIZE=10000000
SAVEHIST=10000000
setopt extended_history
setopt inc_append_history
setopt share_history
setopt hist_reduce_blanks
setopt correct
setopt prompt_subst

# Terminal.app key events in iTerm2.app
# Opt+Left/Right moves between words
# Opt+Shift+Left/Right moves to beginning/end of line
bindkey "^[^[[C" forward-word
bindkey "^[^[[D" backward-word
bindkey "^[[1;10D" beginning-of-line
bindkey "^[[1;10C" end-of-line

autoload -U compinit && compinit
zstyle ':completion:*' menu select
zstyle ':completion:::::' completer _complete _approximate
zstyle ':completion:*:approximate:*' max-errors 3

export HOMEBREW_INSTALL_CLEANUP=1
PURE_PROMPT_SYMBOL=')'

# --- zplug
source ~/.zplug/init.zsh

zplug 'zplug/zplug', hook-build:'zplug --self-manage'
zplug "mafredri/zsh-async", from:github
zplug "sindresorhus/pure", use:pure.zsh, from:github, as:theme

if ! zplug check; then
  printf "hi! install missing zplug plugins? [y/N]: "
  if read -q; then
    echo
    zplug install
  fi
fi
zplug load

export FZF_DEFAULT_OPTS='--color=16'
export MAGICK_HOME='/usr/local/opt/imagemagick@6/'
export EDITOR='nvim'
export GOPATH="$HOME/Code/go"

typeset -U path # enforce uniqueness
path=(
  # langs
  ~/.npm/bin
  ~/.yarn/bin
  ~/Library/Haskell/bin
  $GOPATH/bin
  $HOME/.local/bin
  $HOME/Code/dotfiles/bin
  /usr/local/bin
  $HOME/Code/goog/depot_tools
  $path
)

[ -x "/usr/local/bin/hub" ] && alias git='hub'

alias dk='docker'
alias dkc='docker-compose'
alias br='brew'
alias gi='git init'
alias grb='git rebase'
alias gc='git commit -v'
alias gca='git commit --amend'
alias gco='git checkout'
alias gr='git remote'
alias gd='git diff'
alias gds='git diff --staged'
alias gt='git tag'
alias gst='git status -s'
alias gp='git push'
alias gpl='git pull'
alias grh='git reset HEAD'
alias gs='git show'
alias gsh='git stash'
alias gl="git log --graph"
alias grm='git rm'
alias gb='git branch'
alias ga='git add'
alias gap='git add -p'
alias gcl='git clone'
alias e="$EDITOR"
alias ls='ls -GFh'
alias ll='ls -l'
alias la='ls -al'
alias reload='source ~/.zshrc'
alias usage='du -h -d 1 .'
alias ydl='youtube-dl'
alias ydle='ydl --extract-audio --audio-format mp3'
alias md='mkdir'
alias sc='sudo systemctl'
alias se="sudo -E $EDITOR"
alias irb='irb --simple-prompt'
alias ipy='ipython'
alias bex='bundle exec'
alias py='python3'
if type kitty &> /dev/null; then
  alias ssh='kitty +kitten ssh'
fi
alias s='sudo salt'
alias sa="sudo salt '*'"

gsu() {
  [ ! -n "$1" ] && return
  git remote add origin "$1"
  git push -u origin master
}

# -----------------------------------------------------------------------------
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# export PATH="$PATH:$HOME/.rvm/bin"

# export NVM_DIR="$HOME/.nvm"
# [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
# [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# test -r /Users/slice/.opam/opam-init/init.zsh && . /Users/slice/.opam/opam-init/init.zsh > /dev/null 2> /dev/null || true

[ -d "/usr/local/share/zsh-completions" ] && fpath=(/usr/local/share/zsh-completions $fpath)
