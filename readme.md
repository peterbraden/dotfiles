# Set Up a Vanilla Machine:

## Get Git
[http://git-scm.com/download](http://git-scm.com/download)

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






