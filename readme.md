# Dotfiles

My personal config files and shell scripts for a development machine.

## Tools
- Vim / neovim
- tmux



## Setup a vanilla machine.
<details>
  <summary>See steps</summary>

##### 1. Setup new SSH key and use for github:
```sh
ssh-keygen -t rsa -C "peterbraden@peterbraden.co.uk"
cat ~/.ssh/id_rsa.pub | pbcopy
```
Paste into: [https://github.com/settings/ssh](https://github.com/settings/ssh)

##### 2. Setup
```sh
chezmoi init peterbraden --apply
```

### Setup OSX
#### Install apps from Safari
- [homebrew](https://brew.sh)
- [firefox](https://www.mozilla.org/en-US/firefox/new/)

#### Install apps from App Store
- [ ] 1password
- [ ] [Tailscale](https://apps.apple.com/ca/app/tailscale/id1475387142?mt=12)

#### Install Apps from Firefox
- [iterm](http://www.iterm2.com/#/section/home)
- [nextcloud](https://nextcloud.com/install/#install-clients)

</details>






## Development in this module

### Add vim plugin as submodule for pathogen
```
git submodule add https://github.com/pathto/repo.git vim/bundle/repo.vim
```



