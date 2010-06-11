export PS1="\\w:\$(git branch 2>/dev/null | grep '^*' | colrm 1 2)\$ "
alias todo="python /home/peterbraden/repositories/all-that-stuff/scripts/todo.py -f /home/peterbraden/repositories/web/todo.json"
