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
# Playbooks

## Setup a vanilla machine.
<details>
  <summary>Setup a new desktop machine (dedicated SSH key)</summary>

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
- 1Password
- [Tailscale](https://apps.apple.com/ca/app/tailscale/id1475387142?mt=12)

#### Install Apps from Firefox
- [iterm](http://www.iterm2.com/#/section/home)
- [nextcloud](https://nextcloud.com/install/#install-clients)

</details>

<details>
  <summary>Setup a new ephemeral dev machine in the cloud (SSH agent forwarded)</summary>

```sh
# Setup / Ubuntu / from scratch
# - Requires github authed ssh key
sh -c "$(curl -fsLS get.chezmoi.io)" -- init --apply peterbraden
```

</details>


## Development in this module
<details>
  <summary>Add vim plugin as submodule for pathogen</summary>

```sh
git submodule add https://github.com/pathto/repo.git vim/bundle/repo.vim
```

</details>


# Credit

The config and tools in this repository represent a patchwork of learnings that
have been borrowed or stolen over a long career. While I don't think that things
like this can or should be licensed, (although I may have included whole tools
or repositories, which obviously retain their licenses) I nonetheless want to
credit some of the progenitors of this information. Sadly most of this has been
lost to the sands of time, but in an effort to improve going forward, here is a
list of credits:



- [auto generated git commit messages with LLM](https://harper.blog/2024/03/11/use-an-llm-to-automagically-generate-meaningful-git-commit-messages/)



