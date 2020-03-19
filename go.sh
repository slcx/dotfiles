#!/bin/sh
# vim: ts=2:sts=2:sw=2:et

# go!
#
# slice's mac bootstrap script
# mar 15, 2020

# --

msg() {
  printf "\033[0;32m[go!]\033[0m %s\n" "$@"
}

err() {
  printf "\033[0;31m[error]\033[0m %s\n" "$@"
}

installed() {
  [ -x "$(command -v "$1")" ]
}

is_tapped() {
  [ -d "/usr/local/Homebrew/Library/Taps/$1" ]
}

pause() {
  msg "press enter to proceed"
  read -r
}

die() {
  err "uh oh. dying: $*"
  exit 1
}

beep() {
  printf "\a"
}

brew_install() {
  if ! installed "${2:-$1}"; then
    brew install "$1" || die "failed to install: $1"
  else
    msg "$1 already installed, skipping installation"
  fi
}

cask_install() {
  if ! [ -d "/Applications/$2" ]; then
    brew cask install "$1" || die "failed to install cask: $1"
  else
    msg "$1 already installed, skipping installation"
  fi
}

# --

msg "hello there! c:"
msg "ready to get going?"

pause

msg "caching sudo"
sudo -v

# --

if ! installed brew; then
  msg "installing homebrew"
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)" \
    || die "failed to install homebrew"
else
  msg "homebrew already installed"
fi

msg "installing some essentials"

# utilities
brew_install jq
brew_install htop
brew_install wget
brew_install git
brew_install ffmpeg
brew_install youtube-dl
brew_install ripgrep rg
brew_install coreutils gls
brew_install telnet
brew_install gnupg gpg
brew_install tree
brew_install fzf
brew_install pinentry-mac
brew_install tmux

# programming languages & package managers
brew_install python
brew_install node
brew_install go
brew_install yarn
brew_install ruby
brew_install sbt # scala build tool

# editors
brew_install neovim nvim
brew_install kakoune kak

# databases & services
brew_install postgresql psql
brew_install redis redis-cli
brew_install nginx

# shells
brew_install fish

# casks
! is_tapped "homebrew/homebrew-cask" \
  && brew tap homebrew/cask
! is_tapped "homebrew/homebrew-cask-versions" \
  && brew tap homebrew/cask-versions
cask_install google-chrome "Google Chrome.app"
cask_install iterm2 "iTerm.app"
cask_install sublime-text "Sublime Text.app"
cask_install 1password "1Password 7.app"
cask_install discord "Discord.app"

beep
msg "finished installed packages"

# --

if hostname | grep -q "Mac"; then
  msg "would you like a new hostname? press enter to keep the default"
  printf "? "
  read -r new_hostname

  if [ -n "$new_hostname" ]; then
    # sudo scutil --set HostName "$new_hostname"
    sudo scutil --set LocalHostName "$new_hostname"
    sudo scutil --set ComputerName "$new_hostname"

    msg "alright, new hostname is: $new_hostname"
  else
    msg "skipping new hostname"
  fi
else
  msg "hostname has been changed, not prompting to change"
fi

# --

msg "mapping caps lock to esc"

ioreg -c AppleHSSPIDevice -ra | plutil -convert json - -o /tmp/input.json
product_id=$(jq '.[0].idProduct' /tmp/input.json)
vendor_id=$(jq '.[0].idVendor' /tmp/input.json)
defaults_domain="com.apple.keyboard.modifiermapping.$vendor_id-$product_id-0"

msg "writing to $defaults_domain"

defaults -currentHost write -g "$defaults_domain" -array '
<dict>
  <key>HIDKeyboardModifierMappingSrc</key>
  <integer>30064771129</integer>
  <key>HIDKeyboardModifierMappingDst</key>
  <integer>30064771113</integer>
</dict>
'

# --

msg "cloning dotfiles"

mkdir -p ~/code

if ! [ -d ~/code/dotfiles ]; then
  git clone https://github.com/slice/dotfiles.git ~/code/dotfiles \
    || die "failed to clone dotfiles"
fi

msg "applying defaults"
~/code/dotfiles/defaults.sh || die "failed to apply defaults"
msg "applied defaults"

# --

if ! [ -f ~/.local/share/nvim/site/autoload/plug.vim ]; then
  msg "installing vim-plug"
  curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim \
    || die "failed to download vim-plug"
  msg "installing neovim plugins"
  nvim -c ":PlugInstall" -c ":qa!"
else
  msg "vim-plug already installed, skipping installation"
fi

# --

dscacheutil -flushcache

msg "done!"
