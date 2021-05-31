#!/bin/sh

# Last tested with macOS 11.4

w() {
  echo "defaults write" "$@"
  defaults write "$@"
}

sw() {
  echo "sudo defaults write" "$@"
  sudo defaults write "$@"
}

# Subpixel font anti-aliasing has been gone since macOS 10.14, but it should be
# fine. The default font rendering settings seem to be fine now, so don't
# bother changing them.

# w -g AppleFontSmoothing -int 1
# sw -g AppleFontSmoothing -int 1

# dock
w com.apple.dock tilesize -int 50
w com.apple.dock size-immutable -bool yes
w com.apple.dock show-recents -bool no
w com.apple.dock magnification -float 0
w com.apple.dock mineffect -string "scale"

# finder
# I don't want to test this to see if it still works.
# w com.apple.finder _FXSortFoldersFirst -bool true
w com.apple.finder FXEnableExtensionChangeWarning -bool false
w com.apple.finder FXDefaultSearchScope -string SCcf
w com.apple.finder NewWindowTarget -string PfHm
w com.apple.finder NewWindowPath -string "file:///Users/$(whoami)/"

# spaces
w com.apple.dock mru-spaces -bool false
w com.apple.dock expose-group-apps -bool true

# key repeat
w -g ApplePressAndHoldEnabled -bool false
w -g KeyRepeat -int 2
w -g InitialKeyRepeat -int 15

# keyboard
w -g AppleKeyboardUIMode -int 2 # full keyboard access
w -g NSAutomaticQuoteSubstitutionEnabled -bool false
w -g NSAutomaticCapitalizationEnabled -bool false
w -g NSAutomaticDashSubstitutionEnabled -bool false
w -g NSAutomaticPeriodSubstitutionEnabled -bool false
w -g NSAutomaticSpellingCorrectionEnabled -bool false
w -g NSAutomaticTextCompletionEnabled -bool false # touch bar typing suggestions
w -g NSUserDictionaryReplacementItems -array

# autohide
w com.apple.dock autohide-delay -float 0
w com.apple.dock autohide-time-modifier -float 0.4
w com.apple.dock autohide -bool true
w com.apple.dock showhidden -bool true

# iterm2
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

# accessibility
# sw com.apple.universalaccess reduceMotion -bool true
