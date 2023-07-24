# Dotfiles

My personal config files and shell scripts for a development machine.

I live in a terminal (usually iTerm on a mac), so my full development experience
is defined in these files.

My philosophy is that it's far better to invest in
open source tools that have survived a while because the [Lindy
effect](https://en.wikipedia.org/wiki/Lindy_effect) means that they are likely
to continue to exist for a long time. This has served me well - some of these
configs are almost two decades old, and the muscle memories I developed when
learning them as a junior developer are now so ingrained that my conscious brain
has forgotten a lot of the shortcuts.

It also means I'm more likely to use old, stolid, vintage software where
possible, even if there are some warts. Makefiles, sed, and bash scripts are
more than capable of getting most of the places we need to go.




### Vim

I use vim with a fair amount of [plugins](home/dot_vim/external_bundle) and
[customizations](home/dot_vimrc).

The most important are `,ee` to fuzzy open a file. `,et` and `,ev` to open files
in tabs and vertical splits respectively.

### tmux

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


### [chezmoi](https://www.chezmoi.io/)

For many years, I managed my dotfiles by manually `curl` or `git clone`ing them
onto a new machine, and moving them into place with a hand written makefile.
This worked fine, but Tom, who created chezmoi, would hassle me at the pub about
my suboptimal approach, until eventually I caved and tried it. He was right -
using a tool for this makes everything a lot simpler.

One line machine setups are pretty nice.





---


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

```sh
# Setup / Ubuntu / from scratch
# - Requires github authed ssh key - either forward in agent, or created as above
sh -c "$(curl -fsLS get.chezmoi.io)" -- init --apply peterbraden
```


### Setup OSX
#### Install apps from Safari
- [homebrew](https://brew.sh)
- [firefox](https://www.mozilla.org/en-US/firefox/new/)

#### Install apps from App Store
- 1Password
- [Tailscale](https://apps.apple.com/ca/app/tailscale/id1475387142?mt=12)

#### Install Apps from Firefox
- [iterm](http://www.iterm2.com/#/section/home)
- [nextcloud](https://nextcloud.com/install/#install-clients)

</details>






## Development in this module
<details>
  <summary>Add vim plugin as submodule for pathogen</summary>

```sh
git submodule add https://github.com/pathto/repo.git vim/bundle/repo.vim
```

</details>



