#export PS1="\\w:\$(git branch 2>/dev/null | grep '^*' | colrm 1 2)\$ "

alias vi=vim
alias gp='git pull'
alias gd='git diff'
alias gca='git commit -a'

function psgrep() {
EXP=`echo $1 | sed -e 's/^\(.\)/\[\1\]/'`
ps aux | grep $EXP
}

PATH=$PATH:$HOME/bin

