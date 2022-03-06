if [ -z "$NOTES_DIR" ]; then 
  NOTES_DIR=~/Dropbox/Notebooks/
fi

notes () {
  #ls $NOTES_DIR | grep -i 'month of' | grep --invert-match '.plist$' | sort -r
  ls $NOTES_DIR | grep -i 'week of' | grep --invert-match '.plist$' | sort -r
}

first_note () {
  echo "$NOTES_DIR$(notes | head -n 1)"
}

vi "$(first_note)"
