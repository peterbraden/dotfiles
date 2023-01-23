#!/bin/bash
echo "Running peterbraden/dotfiles install.sh"

if [ "$SHELL" != "/bin/zsh" ]; then 
  echo "# - Changing shell to zsh\n"
  sudo chsh -s $(which zsh) $USER;
fi

if [ $(uname -s) == "Darwin" ]; then
	echo "- Setting up a mac"
	#$(DOTPATH)/osx/install.sh
	#$(DOTPATH)/osx/osx.sh
	#$(DOTPATH)/osx/apps.sh
	#$(DOTPATH)/osx/brew.sh
fi

if [ $(uname -s) == "Linux" ]; then
	echo " -setting up linux"
	#$(DOTPATH)/linux/apt.sh
fi
