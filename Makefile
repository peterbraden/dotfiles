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
