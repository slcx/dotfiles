#!/bin/bash

link() {
  source="$(pwd)/$1"
  target="$2"

  if [[ -e "$target" ]]; then
    echo -n "$target exists, overwrite? [y/n] "
    read -r prompt
    if [[ ! "$prompt" == "y" ]]; then
      return
    fi
  fi

  rm -r "$target"
  ln -s "$source" "$target"
  echo "$source -> $target"
}

link tmux.conf "$HOME/.tmux.conf"
link init.vim "$HOME/.config/nvim/init.vim"
link zshrc "$HOME/.zshrc"
link fish "$HOME/.config/fish"
