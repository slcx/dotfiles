#!/usr/bin/bash

w() {
  echo ">> defaults write" "$@"
  defaults write "$@"
}

# dock
w com.apple.dock tilesize -int 36
w com.apple.dock magnification -float 0
w com.apple.dock mineffect -string "scale"

# finder
w com.apple.finder FXEnableExtensionChangeWarning -bool false

# spaces
w com.apple.dock mru-spaces -bool false
w com.apple.dock dashboard-in-overlay -bool true # disable dashboard
w com.apple.dashboard mcx-disabled -bool true # disable dashboard
w com.apple.dock expose-group-by-app -bool true

# key repeat
w -g ApplePressAndHoldEnabled -bool false # ditch accents for key repeat
w -g KeyRepeat -int 2
w -g InitialKeyRepeat -int 20
w -g AppleFontSmoothing -int 2 # lighter font smoothing

# keyboard
w -g AppleKeyboardUIMode -int 2 # fka

# autohide
w com.apple.dock autohide-delay -float 0
w com.apple.dock autohide-time-modifier -float 0.8
w com.apple.dock autohide -bool true
w com.apple.dock showhidden -bool true

# iterm
w com.googlecode.iterm2 PromptOnQuit -bool false
w com.googlecode.iterm2 QuitWhenAllWindowsClosed -bool false

# terminal
w com.apple.terminal SecureKeyboardEntry -bool true

# accessibility
w com.apple.universalaccess reduceMotion -bool true
