DOTPATH=`pwd`
REPOPATH=~/repos


link_dotfiles:
	echo "=== Linking Dotfiles ===\n"
	ln -s $(DOTPATH)/gitconfig ~/.gitconfig
	ln -s $(DOTPATH)/gitignore ~/.gitignore
	ln -s $(DOTPATH)/hgrc ~/.hgrc
	ln -s $(DOTPATH)/profile ~/.profile
	ln -s $(DOTPATH)/screenrc ~/.screenrc
	ln -s $(DOTPATH)/vimrc ~/.vimrc
	ln -s $(DOTPATH)/zshrc ~/.zshrc
	ln -s $(DOTPATH)/vim ~/.vim
	ln -s $(DOTPATH)/tmuxrc ~/.tmux.conf

add_hosts:
	cat $(DOTPATH)/hosts | sudo tee -a /etc/hosts

change_shell:
	if [ "$SHELL" != "/bin/zsh" ]; then
		echo "- Changing shell to zsh\n"
		chsh -s /bin/zsh
	fi

# Setup Mac -> The last few versions have had _really_ crappy defaults
osx:
	if [ "$(uname)" == 'Darwin' ]; then \
		echo "- Setting up a mac" \
		$DOTPATH/osx \
		make brew_install \
	fi;

brew_install:
	# HOMEBREW
	ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
	sudo mv /usr/bin/vim /usr/bin/system-compiled-vim
	brew install vim
	brew install macvim --override-system-vim
	#brew tap homebrew/dupes
	#brew install screen
	brew install tmux
	brew install ack

node_install:
	sudo curl https://raw.githubusercontent.com/isaacs/nave/master/nave.sh > /usr/local/bin/nave
	sudo nave usemain stable



install: add_hosts change_shell link_dotfiles osx
