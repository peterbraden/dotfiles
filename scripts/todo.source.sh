#!/bin/bash

if [ -z "$NOTES_DIR" ]; then 
  NOTES_DIR=~/Dropbox/Notebooks/
fi

todo_file() {
  #ls $NOTES_DIR | grep -i 'month of' | grep --invert-match '.plist$' | sort -r
  ls $NOTES_DIR | grep -i 'week of' | grep --invert-match '.plist$' | sort -r | head -n 1
}

abs_todo_file(){
  echo "$NOTES_DIR$(todo_file)"
}

todo_today() {
  STRIP_EMPTY='/^[[:space:]]*$/d'
  STRIP_DONE='s/\[[xX]\].*//g'
  STRIP_HEADERS='s/^#.*//g'
  STRIP_NOTES='s/^:.*//g'
  EXIT_DELIMETER='0,/---/p'
  cat "$(abs_todo_file)" | sed $STRIP_DONE  | sed $STRIP_NOTES | sed -n $EXIT_DELIMETER | sed $STRIP_HEADERS | sed $STRIP_EMPTY | head -n 10
}

echo "$(todo_today)"
