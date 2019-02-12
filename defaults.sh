#!/bin/bash

w() {
  echo "> defaults write" "$@"
  defaults write "$@"
}

w -g AppleFontSmoothing -int 1
sudo defaults write -g AppleFontSmoothing -int 1

# dock
w com.apple.dock tilesize -int 50
w com.apple.dock size-immutable -bool yes
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
w -g KeyRepeat -int 1
w -g InitialKeyRepeat -int 20

# keyboard
w -g AppleKeyboardUIMode -int 2 # fka

# autohide
w com.apple.dock autohide-delay -float 0
w com.apple.dock autohide-time-modifier -float 0.4
w com.apple.dock autohide -bool true
w com.apple.dock showhidden -bool true

# iterm
w com.googlecode.iterm2 PromptOnQuit -bool false
w com.googlecode.iterm2 QuitWhenAllWindowsClosed -bool false
w com.googlecode.iterm2 SplitPaneDimmingAmount -float 0.6
w com.googlecode.iterm2 DimOnlyText -bool true
w com.googlecode.iterm2 EnableDivisionView -bool false
w com.googlecode.iterm2 EnableProxyIcon -bool true
w com.googlecode.iterm2 FlashTabBarInFullscreen -bool true
w com.googlecode.iterm2 HideActivityIndicator -bool true
w com.googlecode.iterm2 HideScrollbar -bool true
w com.googlecode.iterm2 HideTab -bool true
w com.googlecode.iterm2 HideTabCloseButton -bool true
w com.googlecode.iterm2 HideTabNumber -bool true

# terminal
w com.apple.terminal SecureKeyboardEntry -bool true

# accessibility
w com.apple.universalaccess reduceMotion -bool true
