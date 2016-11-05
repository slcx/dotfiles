# ~/.bashrc
#
# i usually use zsh, but this is here _just in case_

# if not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls --color=auto'
alias ll='ls -al'
alias la='ls -l'

PS1='[bash \W] '
