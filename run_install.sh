#!/bin/bash
echo "# Running peterbraden/dotfiles install.sh"

if [ "$SHELL" != "/bin/zsh" ]; then 
  echo "# - Changing shell to zsh\n"
  sudo chsh -s $(which zsh) $USER;
fi

DOTPATH=`pwd`

if [ "$(uname -s)" == "Darwin" ]; then
  echo "# - Setting up a mac"

  if [ "$(spctl --status)" == "assessments enabled" ]; then
    echo "# -- Disabling OSX Gatekeeper (spctl)"
    sudo spctl --master-disable
  fi

	#$(DOTPATH)/osx/osx.sh
	#$(DOTPATH)/osx/brew.sh
fi

if [ "$(uname -s)" == "Linux" ]; then
	echo " -setting up linux"
	#$(DOTPATH)/linux/apt.sh
fi
