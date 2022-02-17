#! /bin/bash
# TODO move to dofiles repo

notes_stats () {
  NOTES_DIR="/home/peterbraden/Dropbox"
  cd $NOTES_DIR

  total=0
  files_changed=""
  since=$(date --date="yesterday" --rfc-3339=date)
  first_sha=$(git log --format=format:%H --since="$since" | tail -1)

  echo "# -- Changes since $since -- "
  git diff $first_sha --stat

  for sha in $(git rev-list --since="$since" --abbrev-commit master | sed -e '$ d'); do
    added=$(git diff --word-diff=porcelain $sha~1..$sha|grep -e"^+[^+]"|wc -w|xargs)
    deleted=$(git diff --word-diff=porcelain $sha~1..$sha|grep -e"^-[^-]"|wc -w|xargs)
    duplicated=$(git diff $sha~1..$sha|grep -e"^+[^+]" -e"^-[^-]"|sed -e's/.//'|sort|uniq -d|wc -w|xargs)
    date=$(git show --no-patch --no-notes --pretty='%ci' $sha | cut -c1-16)
    time=$(echo $date | cut -c12-16)
    prefix="- $time:"
    total=$((total+added))

    if [ "$added" -eq "0" ]; then
      changed=$deleted
    else
      changed=$((added+deleted))
    fi
      echo "$prefix $added added, $deleted deleted, $changed changed"
    done

    echo "Total words added:" $total
}
