# Homebrew.
# - inspired by https://github.com/mathiasbynens/dotfiles/blob/master/brew.sh

sudo -v
# Keep-alive: update existing `sudo` time stamp until the script has finished.
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

brew update
brew upgrade

brew bundle --file=- <<-EOS
brew "coreutils"
brew "findutils"
brew "gnu-sed"
brew "cmake"
brew "vim"
brew "reattach-to-user-namespace"# OSX SUCKS!!
brew "tmux"
brew "pass"
brew "ripgrep"
brew "mosh"
brew "pyenv"
EOS

brew cleanup
