# Dotfiles

My personal config files and shell scripts for a development machine.

## Tools

<details>
  <summary>Vim / neovim</summary>
I use vim with a fair amount of [plugins](./home/dot_vim/external_bundle) and
[customizations](./home/dot_vimrc).

The most important are `,ee` to fuzzy open a file. `,et` and `,ev` to open files
in tabs and vertical splits respectively.
</details>

<details>
  <summary>tmux</summary>
tmux is a critical part of my workflow - I use a session per project, so I can
switch between projects and have everything setup how I left it.

`C-a s` Switches projects.

I combine it with a variety of shell scripts to keep everything setup comfortably.

```bash
tmo PROJECT_NAME # Opens the 'current' session for a project, or creates one
                 # with the windows setup how I like. It even attempts to clone
                 # the project from github if it can't find it.

tml # Lists currently open sessions.
```
</details>

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
<details>
  <summary>Add vim plugin as submodule for pathogen</summary>
```
git submodule add https://github.com/pathto/repo.git vim/bundle/repo.vim
```
</details>



