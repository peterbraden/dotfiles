if [ -z "$NOTES_DIR" ]; then 
  NOTES_DIR=~/Dropbox/Notebooks/
fi

notes () {
  ls $NOTES_DIR | grep -i 'month of' | grep --invert-match '.plist$' | sort
}


first_note () {
  echo "$NOTES_DIR$(notes | head)"
}

vi "$(first_note)"
