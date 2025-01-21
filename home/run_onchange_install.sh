#!/usr/bin/env bash
echo "# Running peterbraden/dotfiles install.sh"

if [ "$SHELL" != "/bin/zsh" ]; then 
  echo "# - Changing shell to zsh\n"
  sudo chsh -s "$(which zsh)" $USER;
fi

if [ "$(uname -s)" == "Darwin" ]; then
  echo "# - Setting up a mac"

  # Link repos on desktop
  #ln -s ~/repos ~/Desktop/repos

  if [ "$(spctl --status)" == "assessments enabled" ]; then
    echo "# -- Disabling OSX Gatekeeper (spctl)"
    sudo spctl --master-disable
  fi

  # Top left screen corner → Mission Control [2]
  defaults write com.apple.dock wvous-tl-corner -int 2
  defaults write com.apple.dock wvous-tl-modifier -int 0
  # Top right screen corner → Desktop [4]
  defaults write com.apple.dock wvous-tr-corner -int 4
  defaults write com.apple.dock wvous-tr-modifier -int 0
  # Automatically hide and show the Dock
  defaults write com.apple.dock autohide -bool true
  # Disable touch-style scrolling
  defaults write NSGlobalDomain com.apple.swipescrolldirection -bool false
  # Disable the “Are you sure you want to open this application?” dialog
  defaults write com.apple.LaunchServices LSQuarantine -bool false
  # Disable itunes / apple music
  # launchctl unload -w /System/Library/LaunchAgents/com.apple.rcd.plist || true
  # Kill useless
  defaults write com.apple.gamed Disabled -bool true
fi
