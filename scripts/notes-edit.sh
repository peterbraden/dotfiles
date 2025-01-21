#!/usr/bin/env bash

if [ -z "$NOTES_DIR" ]; then 
  NOTES_DIR=~/Dropbox/Notebooks/
fi

# $@ join to see name
find_most_likely_note() {
  QUERY="$*"
  # TODO use agrep or similar to do fuzzy matching
  FILE=$(find $NOTES_DIR -type f -printf '%T@ %p\n' | grep -i "$QUERY" | sort -r | head -1 | cut -d " " -f 2- )

  if [ -z "$FILE" ]; then 
    echo "No notes found for ${QUERY}"
    exit 1
  fi
  echo $FILE
}

edit_most_likely() {
  if [ -z "$*" ]; then 
    echo "Needs a query."
    exit 1
  fi
  # shellcheck disable=SC2046
  vi $(find_most_likely_note "$@")
}

edit_most_likely "$@"

