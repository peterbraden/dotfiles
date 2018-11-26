DOTPATH=`pwd`
REPOPATH=~/repos
UNAME_S := $(shell uname -s)

install: add_hosts change_shell link_dotfiles linux osx setup_ssh
.PHONY: install
.DEFAULT: install

link_dotfiles:
	git submodule init
	git submodule update
	echo "=== Linking Dotfiles ===\n"
	ln -sf $(DOTPATH)/gitconfig ~/.gitconfig
	ln -sf $(DOTPATH)/gitignore ~/.gitignore
	ln -sf $(DOTPATH)/hgrc ~/.hgrc
	ln -sf $(DOTPATH)/inputrc ~/.inputrc
	ln -sf $(DOTPATH)/profile ~/.profile
	ln -sf $(DOTPATH)/screenrc ~/.screenrc
	ln -sf $(DOTPATH)/shortcuts.vim ~/shortcuts.vim
	ln -sf $(DOTPATH)/tmuxrc ~/.tmux.conf
	ln -sf $(DOTPATH)/vimrc.vim ~/.vimrc
	ln -sf $(DOTPATH)/vim ~/.vim
	ln -sf $(DOTPATH)/zshrc ~/.zshrc
	ln -sf $(DOTPATH)/muttrc ~/.muttrc
	mkdir -p ~/.vimundo
.PHONY: link_dotfiles

add_hosts:
	#grep -c 'PB HOSTS' /etc/hosts || cat $(DOTPATH)/hosts | sudo tee -a /etc/hosts
	## Symlinks don't currently work on osx
	#sudo ln -sf $(DOTPATH)/hosts /etc/hosts
	#dscacheutil -flushcache
	#sudo killall -HUP mDNSResponder
.PHONY: add_hosts

# Use ZSH
change_shell: linux
	if [ "$$SHELL" != "/bin/zsh" ]; then \
		echo "- Changing shell to zsh\n"; \
		sudo chsh --shell $(shell which zsh) $$USER; \
	fi;
.PHONY: change_shell

# Setup Mac -> The last few versions have had _really_ crappy defaults
osx:
ifeq ($(UNAME_S), Darwin)
	echo "- Setting up a mac"
	$(DOTPATH)/osx/osx.sh
	$(DOTPATH)/osx/apps.sh
	$(DOTPATH)/osx/brew.sh
endif
.PHONY: osx


linux:
ifeq ($(UNAME_S), Linux)
	echo " -setting up linux"
	$(DOTPATH)/linux/apt.sh
endif
.PHONY: linux

node_install:
	sudo curl https://raw.githubusercontent.com/isaacs/nave/master/nave.sh > /usr/local/bin/nave
	sudo nave usemain stable
.PHONY: node_install

setup_ssh:
	#mkdir -p ~/.ssh
	#cp $(DOTPATH)/ssh/authorized_keys ~/.ssh
	#cp $(DOTPATH)/ssh/sshd_config ~/.ssh
	#cp $(DOTPATH)/ssh/config ~/.ssh
.PHONY: setup_ssh

