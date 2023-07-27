#!/bin/bash

#sudo -v
# Keep-alive: update existing `sudo` time stamp until the script has finished.
#while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

if [ "$(uname -s)" == "Darwin" ]; then
  echo "# - Installing packages on a mac"

  # Homebrew.
  # - inspired by https://github.com/mathiasbynens/dotfiles/blob/master/brew.sh
  # - ref. https://gist.github.com/ChristopherA/a579274536aab36ea9966f301ff14f3f

  brew update
  brew upgrade

brew bundle --file=- <<-EOS
brew "coreutils"
brew "findutils"
brew "gnu-sed"
brew "cmake"
brew "vim"
brew "reattach-to-user-namespace"
brew "tmux"
brew "pass"
brew "ripgrep"
brew "mosh"
brew "pyenv"
brew "bash"
brew "git"
brew "neovim"

brew "exa"     # Ls replacement
brew "atuin"   # Pretty history
brew "fd"      # Find replacement
brew "bat"     # Cat replacement
EOS

  brew cleanup

fi

if [ "$(uname -s)" == "Linux" ]; then

  # Update Apt sources --------------------------------------------------------

  # Tailscale
  curl -fsSL https://pkgs.tailscale.com/stable/ubuntu/focal.noarmor.gpg | sudo tee /usr/share/keyrings/tailscale-archive-keyring.gpg >/dev/null
  curl -fsSL https://pkgs.tailscale.com/stable/ubuntu/focal.tailscale-keyring.list | sudo tee /etc/apt/sources.list.d/tailscale.list

  # One Password
  curl -sS https://downloads.1password.com/linux/keys/1password.asc | sudo gpg --dearmor --output /usr/share/keyrings/1password-archive-keyring.gpg
  echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/1password-archive-keyring.gpg] https://downloads.1password.com/linux/debian/$(dpkg --print-architecture) stable main" | sudo tee /etc/apt/sources.list.d/1password.list
  sudo mkdir -p /etc/debsig/policies/AC2D62742012EA22/
  curl -sS https://downloads.1password.com/linux/debian/debsig/1password.pol | \
  sudo tee /etc/debsig/policies/AC2D62742012EA22/1password.pol
  sudo mkdir -p /usr/share/debsig/keyrings/AC2D62742012EA22
  curl -sS https://downloads.1password.com/linux/keys/1password.asc | \
  sudo gpg --dearmor --output /usr/share/debsig/keyrings/AC2D62742012EA22/debsig.gpg


  sudo apt -y update
  #sudo apt -y upgrade

  # Apt get stuff -------------------------------------------------------------
  sudo apt install -y build-essential
  sudo apt install -y python python-pip python-setuptools python-dev
  sudo apt install -y nodejs npm
  sudo apt install -y rustc cargo
  sudo apt install -y zsh vim
  sudo apt install -y neovim 
  sudo apt install -y ripgrep
  sudo apt install -y pass
  sudo apt install -y mosh
  sudo apt install -y tailscale
  sudo apt install -y bat
  sudo apt install -y 1password-cli
fi

