#!/bin/bash

link() {
  source="$(pwd)/$1"
  target="$2"

  if [[ ! -e "$source" ]]; then
    echo "err: cannot find $source"
    return
  fi

  if [[ -e "$target" ]]; then
    echo -n "$target exists, overwrite? [y/n] "
    read -r prompt
    if [[ ! "$prompt" == "y" ]]; then
      return
    fi
  fi

  rm -r "$target"
  ln -s "$source" "$target"
  echo -e "\033[32m✔ $source → $target\033[0m"
}

# link some stuff
link tmux.conf "$HOME/.tmux.conf"
link init.vim "$HOME/.config/nvim/init.vim"
link zshrc "$HOME/.zshrc"
link fish "$HOME/.config/fish"
link Preferences.sublime-settings "$HOME/Library/Application Support/Sublime Text 3/Packages/User/Preferences.sublime-settings"
link vscode_settings.json "$HOME/Library/Application Support/Code - Insiders/User/settings.json"
