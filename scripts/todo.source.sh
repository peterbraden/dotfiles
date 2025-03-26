#!/bin/bash

if [ -z "$NOTES_DIR" ]; then
  NOTES_DIR=~/nextcloud/Notes/Notebooks/
fi

todo_files() {
  grep -i 'week of' $NOTES_DIR/* | grep --invert-match '.plist$' | sort --ignore-case -r 
}

todo_file() {
  grep -i 'week of' $NOTES_DIR/* | grep --invert-match '.plist$' | sort --ignore-case -r | head -n 1
}

abs_todo_file(){
  echo "$NOTES_DIR$(todo_file)"
}


todo_today() {
  # STRIP_EMPTY='/^[[:space:]]*$/d'
  # STRIP_DONE='s/\[[xX]\].*//g'
  # STRIP_HEADERS='s/^#.*//g'
  # STRIP_NOTES='s/^:.*//g'
  # EXIT_DELIMETER='0,/---/p' # Quit after first '---' (| sed -n $EXIT_DELIMETER)
  #cat "$(abs_todo_file)" | head -n 10
  #cat "$(abs_todo_file)" | sed $STRIP_DONE  | sed $STRIP_NOTES  | sed $STRIP_HEADERS | sed $STRIP_EMPTY | head -n 15

  cat <<EOF | \
  PYTHONPATH=$DOTPATH/scripts \
  todofile="$(abs_todo_file)" \
  python3 -
import os
import todos

f=os.environ["todofile"]
print(todos.todo_today(f))

EOF
}
