# Set Up a Vanilla Machine:

## Install Xcode from app store
Because Apple need a user account to give you a compiler...

## Remove OSX's dumb app security
```sh
sudo spctl --master-disable
```
System Prefs > Security > Allow Apps from anywhere

## Get Git
[http://git-scm.com/download](http://git-scm.com/download)

## Get Keys from old Machine

- SSH Keys
- Private Key etc

## Setup Github keys:
```sh
ssh-keygen -t rsa -C "peterbraden@peterbraden.co.uk"
cat ~/.ssh/id_rsa.pub | pbcopy
```

Paste into: [https://github.com/settings/ssh](https://github.com/settings/ssh)

## Setup
```sh
cd
mkdir ~/repos
git clone git@github.com:peterbraden/dotfiles.git && cd dotfiles
make
```

# Pathogen add

```
git submodule add https://github.com/pathto/repo.git vim/bundle/repo.vim

```

- Set lock screen message with contact info


