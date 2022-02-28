# Set Up a Vanilla Machine:

## Remove OSX's dumb app security
```sh
sudo spctl --master-disable
```
System Prefs > Security > Allow Apps from anywhere

## Install apps from Safari
- https://brew.sh

# Install apps from App Store
- 1password

## Install Git
`brew install git`

## Login Github

## Setup Github keys:
```bash
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


