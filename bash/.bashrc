#
# ~/.bashrc
#

# if not running interactively, don't do anything
[[ $- != *i* ]] && return

if [[ -x /usr/bin/nvim ]] || [[ -x /usr/local/bin/nvim ]]; then
  export EDITOR=nvim
elif [[ -x /usr/bin/vim ]] || [[ -x /bin/vim ]]; then
  export EDITOR=vim
else
  echo "what? no nvim or vim on this system, falling back to \`vi'."
  export EDITOR=vi
fi

alias ls='ls --color=auto -hF'
alias cp='cp -r'
alias e='$EDITOR'

PS1='ssh \u@\h \W% '

export PATH="$PATH:$HOME/.rvm/bin" # Add RVM to PATH for scripting
