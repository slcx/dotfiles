# dock
defaults write com.apple.dock tilesize -int 36
defaults write com.apple.dock magnification -float 0
defaults write com.apple.dock mineffect -string "scale"

# finder
defaults write com.apple.finder FXEnableExtensionChangeWarning -bool false

# spaces
defaults write com.apple.dock mru-spaces -bool false
defaults write com.apple.dock dashboard-in-overlay -bool true
defaults write com.apple.dashboard mcx-disabled -bool true
defaults write com.apple.dock expose-group-by-app -bool true

# key repeat
defaults write NSGlobalDomain ApplePressAndHoldEnabled -bool false
defaults write NSGlobalDomain KeyRepeat -int 3
defaults write NSGlobalDomain InitialKeyRepeat -int 20

# keyboard
defaults write NSGlobalDomain AppleKeyboardUIMode -int 2

# autohide
defaults write com.apple.dock autohide-delay -float 0
defaults write com.apple.dock autohide-time-modifier -float 0.8
defaults write com.apple.dock autohide -bool true
defaults write com.apple.dock showhidden -bool true

# terminal
defaults write com.apple.terminal SecureKeyboardEntry -bool true

# accessibility
defaults write com.apple.universalaccess reduceMotion -bool true
