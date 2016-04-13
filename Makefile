DOTPATH=`pwd`
REPOPATH=~/repos

install: add_hosts change_shell link_dotfiles osx setup_ssh
.PHONY: install
.DEFAULT: install

link_dotfiles:
	echo "=== Linking Dotfiles ===\n"
	ln -sf $(DOTPATH)/gitconfig ~/.gitconfig
	ln -sf $(DOTPATH)/gitignore ~/.gitignore
	ln -sf $(DOTPATH)/hgrc ~/.hgrc
	ln -sf $(DOTPATH)/profile ~/.profile
	ln -sf $(DOTPATH)/screenrc ~/.screenrc
	ln -sf $(DOTPATH)/vimrc.vim ~/.vimrc
	ln -sf $(DOTPATH)/zshrc ~/.zshrc
	ln -sf $(DOTPATH)/vim ~/.vim
	ln -sf $(DOTPATH)/tmuxrc ~/.tmux.conf
	ln -sf $(DOTPATH)/shortcuts.vim ~/shortcuts.vim
	mkdir -p ~/.vimundo
.PHONY: link_dotfiles

add_hosts:
	grep -c 'PB HOSTS' /etc/hosts || cat $(DOTPATH)/hosts | sudo tee -a /etc/hosts
.PHONY: add_hosts

# Use ZSH
change_shell:
	if [ "$$SHELL" != "/bin/zsh" ]; then \
		echo "- Changing shell to zsh\n"; \
		chsh -s /bin/zsh; \
	fi;
.PHONY: change_shell

# Setup Mac -> The last few versions have had _really_ crappy defaults
osx:
	if [ "$(uname)" == 'Darwin' ]; then \
		echo "- Setting up a mac" \
		$DOTPATH/osx/osx.sh \
		$DOTPATH/osx/osx-apps.sh \
		$DOTPATH/osx/brew.sh \
	fi;
.PHONY: osx

node_install:
	sudo curl https://raw.githubusercontent.com/isaacs/nave/master/nave.sh > /usr/local/bin/nave
	sudo nave usemain stable
.PHONY: node_install

setup_ssh:
	mkdir -p ~/.ssh
	cp $(DOTPATH)/ssh/authorized_keys ~/.ssh
	cp $(DOTPATH)/ssh/sshd_config ~/.ssh
	cp $(DOTPATH)/ssh/config ~/.ssh
.PHONY: setup_ssh

