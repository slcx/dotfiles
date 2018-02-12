# if not running interactively, don't do anything
[[ $- != *i* ]] && return

export EDITOR='nvim'
export PATH="$PATH:~/bin"

alias git='hub'
alias g='git'
alias sb='subl3'
alias ls='ls -AhF --color=auto'
alias pm='pacman'
alias spm='sudo pacman'
alias reload='source ~/.bashrc'
alias trz='trizen'
alias e="$EDITOR"

PS1='\W\$ '
