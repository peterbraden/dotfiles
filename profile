# ====== ALIASES ======
alias vi=vim

# GIT
alias gp='git pull'
alias gd='git diff'
alias gs='git status'
alias gca='git commit -a'
alias gl='git log -p'

alias d="date --rfc-3339=seconds"
alias shipr="last peterbraden -n 1 -i | grep 'still logged in' | awk '{print \$3}'"
alias shlocr="geoiplookup \$(shipr) | grep 'Rev 1'  |  awk '{print \$11,\$12}'"

# SSH
alias prom='ssh peterbraden@prometheus'

function psgrep() {
EXP=`echo $1 | sed -e 's/^\(.\)/\[\1\]/'`
ps aux | grep $EXP
}


PATH=$PATH:$HOME/bin:./node_modules/.bin


SSHAGENT=/usr/bin/ssh-agent
SSHAGENTARGS="-s"

if [ -z "$SSH_AUTH_SOCK" -a -x "$SSHAGENT" ]; then
	eval `$SSHAGENT $SSHAGENTARGS`
	trap "kill $SSH_AGENT_PID" 0
fi

export HISTSIZE=10000

