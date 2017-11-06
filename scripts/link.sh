#!/bin/bash

overwrite_all="off"

usage() {
  echo "usage: bash scripts/link.sh [-o: overwrite all]"
}

while getopts ":o" opt; do
  case ${opt} in
    o )
      overwrite_all="on"
      ;;
    * )
      usage
      exit 1
      ;;
  esac
done

if [[ "$(uname)" != "Darwin" ]]; then
  echo "err: this script is only compatible on macOS/OSX."
  exit 1
fi

link() {
  source="$(pwd)/$1"
  target="$2"

  if [[ ! -e "$source" ]]; then
    echo "err: cannot find $source"
    return
  fi

  if [[ -e "$target" ]] && [[ "$overwrite_all" == "off" ]]; then
    echo -n "$target exists, overwrite? [y/n] "
    read -r prompt
    if [[ ! "$prompt" == "y" ]]; then
      return
    fi
  fi

  rm -rf "$target"
  ln -s "$source" "$target"
  echo -e "\033[32m✔ $source → $target\033[0m"
}

application_support="$HOME/Library/Application Support"

# programs:
link tmux.conf "$HOME/.tmux.conf"

# shells:
link zshrc "$HOME/.zshrc"
link fish "$HOME/.config/fish"

# editors:
link "editors/sublime_settings.json" "$application_support/Sublime Text 3/Packages/User/Preferences.sublime-settings"
link "editors/vscode_settings.json" "$application_support/Code - Insiders/User/settings.json"
link "editors/init.vim" "$HOME/.config/nvim/init.vim"

# linters:
link "linters/flake8" "$HOME/.config/flake8"
link "linters/eslintrc.json" "$HOME/.eslintrc"
