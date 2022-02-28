# Set Up a Vanilla Machine:



## OSX
System Prefs > Security > Allow Apps from anywhere

### Install apps from Safari
- https://brew.sh
- https://www.mozilla.org/en-US/firefox/new/

### Install apps from App Store
- [ ] 1password

### Install Git
`brew install git`

### Login Github

### Setup Github keys:
```bash
ssh-keygen -t rsa -C "peterbraden@peterbraden.co.uk"
cat ~/.ssh/id_rsa.pub | pbcopy
```
Paste into: [https://github.com/settings/ssh](https://github.com/settings/ssh)

### Setup
```sh
cd
mkdir ~/repos
git clone git@github.com:peterbraden/dotfiles.git && cd dotfiles
make
```


- Set lock screen message with contact info

# Playbook

### Pathogen add module
```
git submodule add https://github.com/pathto/repo.git vim/bundle/repo.vim
```



