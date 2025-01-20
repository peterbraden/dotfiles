#!/usr/bin/env bash

if [ -z "$NOTES_DIR" ]; then 
  NOTES_DIR=~/Dropbox/Notebooks/
fi

list_notes() {
  ls $NOTES_DIR -1tr | tail -n 20
}

list_notes
