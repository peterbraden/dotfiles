# ====== ALIASES ======
alias vi=vim

# GIT
alias gp='git pull'
alias gd='git diff'
alias gs='git status'
alias gca='git commit -a'
alias gl='git log -p'


# SSH
alias prom='ssh peterbraden@prometheus'

function psgrep() {
EXP=`echo $1 | sed -e 's/^\(.\)/\[\1\]/'`
ps aux | grep $EXP
}


PATH=$PATH:$HOME/bin

