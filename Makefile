DOTPATH=`pwd`
REPOPATH=~/repos
UNAME_S := $(shell uname -s)

install: add_hosts change_shell link_dotfiles linux osx
.PHONY: install
.DEFAULT: install

link_dotfiles:
	git submodule init
	git submodule update --init --recursive
	chezmoi apply
	mkdir -p ~/.vimundo
	mkdir -p ~/.history

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
		echo "# - Changing shell to zsh\n"; \
		sudo chsh -s $(shell which zsh) $$USER; \
	fi;
.PHONY: change_shell

# Setup Mac -> The last few versions have had _really_ crappy defaults
osx:
ifeq ($(UNAME_S), Darwin)
	echo "- Setting up a mac"
	$(DOTPATH)/osx/install.sh
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

