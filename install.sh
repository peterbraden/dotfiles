#!/bin/bash
DOTPATH=`pwd`

echo "=== Linking Dotfiles ===\n"

ln -s $DOTPATH/gitconfig ~/.gitconfig
ln -s $DOTPATH/gitignore ~/.gitignore
ln -s $DOTPATH/hgrc ~/.hgrc
ln -s $DOTPATH/profile ~/.profile
ln -s $DOTPATH/screenrc ~/.screenrc
ln -s $DOTPATH/vimrc ~/.vimrc
ln -s $DOTPATH/zshrc ~/.zshrc
ln -s $DOTPATH/vim ~/.vim

if [ "$SHELL" != "/bin/zsh" ]; then
  echo "=== Changing shell to zsh ===\n"
  chsh -s /bin/zsh
fi  

# ============== Tools =================
echo "=== Installing tools ===\n"

#echo "\n\n--> Ack\n"
#curl http://betterthangrep.com/ack-standalone > ~/bin/ack && chmod 0755 ~/bin/ack

#echo "\n\n--> Node\n"
#git clone https://github.com/joyent/node.git && cd node &&  ./configure && make && sudo make install && cd .. && rm -rf node

#echo "--> NPM"
#git clone https://github.com/isaacs/npm.git && cd npm && make && sudo make install
