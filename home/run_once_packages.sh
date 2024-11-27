#!/usr/bin/env bash



# OSX {{{
if [ "$(uname -s)" == "Darwin" ]; then

  echo "# Installing packages on a mac" >&2

  if ! [ -x "$(command -v brew)" ]; then
    echo "# - Installing brew" >&2
    bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  fi

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

brew "fzf"     # Fuzzy find
brew "atuin"   # Pretty history
brew "fd"      # Find replacement
brew "bat"     # Cat replacement
brew "eza"     # ls replacement
brew "zoxide"  # cd replacement
brew "git-delta"

EOS

  brew cleanup

#pip install llm
# TODO 1password
# TODO rclone

fi

# }}}

# Linux {{{



if sudo true; then
  #sudo -v
  # Keep-alive: update existing `sudo` time stamp until the script has finished.
  #while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &
  if [ "$(uname -s)" == "Linux" ]; then
    if [ -n "$(command -v apt-get)" ]; then
      # Apt get stuff.
      sudo apt-get -y update
      sudo apt-get -y upgrade
      sudo apt-get install -y build-essential
      sudo apt-get install -y python python-pip python-setuptools python-dev
      sudo apt-get install -y nodejs npm
      sudo apt-get install -y rustc cargo
      sudo apt-get install -y awscli zsh vim
      sudo apt-get install -y mosh
      sudo apt-get install -y neovim ripgrep
      sudo apt-get install -y pass
      # TODO tailscale
      #
      #apt install bat
    fi
  fi
fi
# }}}
