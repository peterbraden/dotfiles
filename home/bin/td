#!/bin/bash
if [ -z "$DOTPATH"  ]; then
  echo "Missing DOTPATH"
  exit 1
fi

source "$DOTPATH/scripts/todo.source.sh"

vi "$(abs_todo_file)"
