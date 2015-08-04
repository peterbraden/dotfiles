# Set Up a Vanilla Machine:

## Install Xcode from app store
Because Apple need a user account to give you a compiler...

## Remove OSX's dumb app security
System Prefs > Security > Allow Apps from anywhere

## Get Git
[http://git-scm.com/download](http://git-scm.com/download)

## Get Keys from old Machine

- SSH Keys
- Private Key etc

## Setup Github keys:
```shell
ssh-keygen -t rsa -C "peterbraden@peterbraden.co.uk"
cat ~/.ssh/id_rsa.pub | pbcopy
```

Paste into:
```shell
https://github.com/settings/ssh
```

## Setup
```shell
cd;
mkdir ~/repos;

git clone git@github.com:peterbraden/dotfiles.git && cd dotfiles
./install.sh
```






