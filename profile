# ====== ALIASES ======
alias vi=vim

# GIT
alias gp='git pull'
alias gd='git diff'
alias gs='git status'
alias gca='git commit -a'
alias gl='git log -p'
alias glg='git log --graph --pretty=format:"%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset" --abbrev-commit'

# Shortcuts
alias d="date --rfc-3339=seconds"
alias genpwd="openssl rand -base64 20"

# SSH
alias prom='ssh peterbraden@prometheus'

# TMUX
# - supports 256 colors
alias tmux=tmux -2
# attach or create session - similar to `screen -dR foo`
alias tm='tmux new-session -AD'

function psgrep() {
EXP=`echo $1 | sed -e 's/^\(.\)/\[\1\]/'`
ps aux | grep $EXP
}

function ip(){
ifconfig | grep -Eo 'inet (addr:)?([0-9]*\.){3}[0-9]*' | grep -Eo '([0-9]*\.){3}[0-9]*' | grep -v '127.0.0.1'
}


PATH=$PATH:$HOME/bin:./node_modules/.bin
PATH=/opt/local/bin:/opt/local/sbin:$PATH

SSHAGENT=/usr/bin/ssh-agent
SSHAGENTARGS="-s"

if [ -z "$SSH_AUTH_SOCK" -a -x "$SSHAGENT" ]; then
	eval `$SSHAGENT $SSHAGENTARGS`
	trap "kill $SSH_AGENT_PID" 0
fi

export HISTSIZE=10000

extract () {
    if [ -f $1 ] ; then
      case $1 in
        *.tar.bz2)   tar xjf $1     ;;
        *.tar.gz)    tar xzf $1     ;;
        *.bz2)       bunzip2 $1     ;;
        *.rar)       unrar e $1     ;;
        *.gz)        gunzip $1      ;;
        *.tar)       tar xf $1      ;;
        *.tbz2)      tar xjf $1     ;;
        *.tgz)       tar xzf $1     ;;
        *.zip)       unzip $1       ;;
        *.Z)         uncompress $1  ;;
        *.7z)        7z x $1        ;;
        *)     echo "'$1' cannot be extracted via extract()" ;;
         esac
     else
         echo "'$1' is not a valid file"
     fi
}


export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8

export DOCKER_HOST=tcp://127.0.0.1:4243
