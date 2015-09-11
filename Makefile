DOTPATH=`pwd`
REPOPATH=~/repos


link_dotfiles:
	echo "=== Linking Dotfiles ===\n"
	ln -sf $(DOTPATH)/gitconfig ~/.gitconfig
	ln -sf $(DOTPATH)/gitignore ~/.gitignore
	ln -sf $(DOTPATH)/hgrc ~/.hgrc
	ln -sf $(DOTPATH)/profile ~/.profile
	ln -sf $(DOTPATH)/screenrc ~/.screenrc
	ln -sf $(DOTPATH)/vimrc ~/.vimrc
	ln -sf $(DOTPATH)/zshrc ~/.zshrc
	ln -sf $(DOTPATH)/vim ~/.vim
	ln -sf $(DOTPATH)/tmuxrc ~/.tmux.conf

add_hosts:
	grep -c 'PB HOSTS' /etc/hosts || cat $(DOTPATH)/hosts | sudo tee -a /etc/hosts

change_shell:
	if [ "$$SHELL" != "/bin/zsh" ]; then \
		echo "- Changing shell to zsh\n"; \
		chsh -s /bin/zsh; \
	fi;

# Setup Mac -> The last few versions have had _really_ crappy defaults
osx:
	if [ "$(uname)" == 'Darwin' ]; then \
		echo "- Setting up a mac" \
		$DOTPATH/osx/osx.sh \
		$DOTPATH/osx/osx-apps.sh \
		$DOTPATH/osx/brew.sh \
	fi;

node_install:
	sudo curl https://raw.githubusercontent.com/isaacs/nave/master/nave.sh > /usr/local/bin/nave
	sudo nave usemain stable



install: add_hosts change_shell link_dotfiles osx
