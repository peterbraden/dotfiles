# System Setup Mac


- Visor: http://totalterminal.binaryage.com/
- Git: http://git-scm.com/download
- Firefox: http://www.mozilla.org/en-US/firefox/channel/
- Evernote: http://www.evernote.com/
- Flux: http://stereopsis.com/flux/
- Sublime text

    sudo ln -s "/Applications/Sublime Text 2.app/Contents/SharedSupport/bin/subl" /usr/bin/subl




## Setup github keys:

    ssh-keygen -t rsa -C "peterbraden@peterbraden.co.uk"
    cat ~/.ssh/id_rsa.pub | pbcopy


## Setup Dotfiles
 
    git clone git@github.com:peterbraden/dotfiles.git && cd dotfiles
    ./install.sh



 ## Install Node
 
    git clone https://github.com/joyent/node.git && cd node
    ./configure
    make
    sudo make install
    cd ..
    git clone https://github.com/isaacs/npm.git && cd npm
    make
    sudo make install