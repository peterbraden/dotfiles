# Apt get stuff.

sudo -v
# Keep-alive: update existing `sudo` time stamp until the script has finished.
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

sudo apt-get -y update
sudo apt-get -y upgrade

sudo apt-get install -y build-essential
sudo apt-get install -y python python-pip python-setuptools python-dev
sudo apt-get install -y nodejs npm
sudo apt-get install -y rustc cargo
sudo apt-get install -y awscli zsh vim
sudo apt-get install -y mosh


