#!/usr/bin/env bash

notes_stats () {
  NOTES_DIR=~/nextcloud/Notes/Notebooks/
  cd $NOTES_DIR
  cd $NOTES_DIR || exit 1

  total=0
  since=$(date --date="yesterday" --rfc-3339=date)
  first_sha=$(git log --format=format:%H --since="$since" | tail -1)

  echo "# -- Changes since $since -- "
  echo ""
  git diff $first_sha --numstat | sort -nr | sed "s/Notebooks\///" | sed "s/.txt//" | awk '{s = ""; for (i = 3; i <= NF; i++) s = s $i " "; print s "," $1 "+ ," $2 "- " }' | column -t -s,
  echo ""

  for sha in $(git rev-list --since="$since" --abbrev-commit master | sed -e '$ d'); do
    added=$(git diff --word-diff=porcelain $sha~1..$sha|grep -e"^+[^+]"|wc -w|xargs)
    deleted=$(git diff --word-diff=porcelain $sha~1..$sha|grep -e"^-[^-]"|wc -w|xargs)
    #duplicated=$(git diff $sha~1..$sha|grep -e"^+[^+]" -e"^-[^-]"|sed -e's/.//'|sort|uniq -d|wc -w|xargs)
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

    echo ""
    echo "Total words added:" $total
}
