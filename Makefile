DOTPATH=`pwd`


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

add_hosts:
	cat $(DOTPATH)/hosts | sudo tee -a /etc/hosts


change_shell:
	if [ "$SHELL" != "/bin/zsh" ]; then
		echo "=== Changing shell to zsh ===\n"
		chsh -s /bin/zsh
	fi
