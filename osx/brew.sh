# Homebrew.
# - inspired by https://github.com/mathiasbynens/dotfiles/blob/master/brew.sh

sudo -v
# Keep-alive: update existing `sudo` time stamp until the script has finished.
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

# Install homebrew
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"

brew update
brew upgrade

brew install coreutils
sudo ln -s /usr/local/bin/gsha256sum /usr/local/bin/sha256sum

# Install some other useful utilities like `sponge`.
brew install moreutils
# Install GNU `find`, `locate`, `updatedb`, and `xargs`, `g`-prefixed.
brew install findutils
# Install GNU `sed`, overwriting the built-in `sed`.
brew install gnu-sed

brew install cmake


# Vim
sudo mv /usr/bin/vim /usr/bin/system-compiled-vim
brew install vim
brew install macvim 
brew install neovim

brew install homebrew/grep
brew install homebrew/openssh
brew install homebrew/screen

brew install reattach-to-user-namespace # OSX SUCKS!!

brew install tmux
brew install git
brew install pass
brew install ripgrep

brew cleanup

