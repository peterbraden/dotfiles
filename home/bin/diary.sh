#!/usr/bin/env bash

if [ -z "$NOTES_DIR" ]; then 
  NOTES_DIR=~/nextcloud/Notes/Notebooks/
fi

name() {
  echo "$NOTES_DIR$(date '+%Y-%m-%d').txt"
}

vi "$(name)"
