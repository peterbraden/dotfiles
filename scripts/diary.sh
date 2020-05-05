if [ -z "$NOTES_DIR" ]; then 
  NOTES_DIR=~/Dropbox/Notebooks/
fi

name() {
  echo "$NOTES_DIR$(date '+%Y-%m-%d').txt"
}

vi "$(name)"
