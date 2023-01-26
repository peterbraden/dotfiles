# Bootstrapping on a Vanilla Machine:
### Setup Github keys:
```bash
ssh-keygen -t rsa -C "peterbraden@peterbraden.co.uk"
cat ~/.ssh/id_rsa.pub | pbcopy
```
Paste into: [https://github.com/settings/ssh](https://github.com/settings/ssh)

### Setup
```sh
chezmoi init peterbraden --branch=chezmoi
```

## OSX
### Install apps from Safari
- [homebrew](https://brew.sh)
- [firefox](https://www.mozilla.org/en-US/firefox/new/)

### Install apps from App Store
- [ ] 1password
- [ ] [Tailscale](https://apps.apple.com/ca/app/tailscale/id1475387142?mt=12)

# Install Apps from Firefox
- [iterm](http://www.iterm2.com/#/section/home)
- [nextcloud](https://nextcloud.com/install/#install-clients)

- Set lock screen message with contact info

# Playbook

### Pathogen add module
```
git submodule add https://github.com/pathto/repo.git vim/bundle/repo.vim
```



