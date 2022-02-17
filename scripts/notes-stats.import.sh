#! /bin/bash
# TODO move to dofiles repo

notes_stats () {
  NOTES_DIR="/home/peterbraden/Dropbox"
  cd $NOTES_DIR

  total=0
  files_changed=""
  since=$(date --date="2 days ago" --rfc-3339=date)
  first_sha=$(git log --format=format:%H --since="$since" | tail -1)


  for sha in $(git rev-list --since="$since" --abbrev-commit master | sed -e '$ d'); do
    added=$(git diff --word-diff=porcelain $sha~1..$sha|grep -e"^+[^+]"|wc -w|xargs)
    deleted=$(git diff --word-diff=porcelain $sha~1..$sha|grep -e"^-[^-]"|wc -w|xargs)
    duplicated=$(git diff $sha~1..$sha|grep -e"^+[^+]" -e"^-[^-]"|sed -e's/.//'|sort|uniq -d|wc -w|xargs)
    date=$(git show --no-patch --no-notes --pretty='%ci' $sha | cut -c1-16)
    prefix="- $sha $date :"
    total=$((total+added))

    changed=$(git diff --name-only $sha; echo x) # Bash sucks - trims trailing newlines
    changed="${changed%?}" #strip the trailing x
    files_changed+="$changed"
    if [ "$added" -eq "0" ]; then
      changed=$deleted
      echo "$prefix added:" $added, "deleted:" $deleted, "duplicated:"\
        $duplicated, "changed:" $changed
    elif [ "$(echo "$duplicated/$added > 0.8" | bc -l)" -eq "1" ]; then
      echo "$prefix added:" $added, "deleted:" $deleted, "duplicated:"\
       $duplicated, "changes counted:" 0
    else
      changed=$((added+deleted))
      echo "$prefix added:" $added, "deleted:" $deleted, "duplicated:"\
                       $duplicated, "changes counted:" $changed
    fi
    done

    echo "# Changes since $since"
    echo "$files_changed" | sort | uniq
    echo "Total words added:", $total
    git log --shortstat --since="$since" | grep "files changed" | awk '{files+=$1; inserted+=$4; deleted+=$6} END {print "Files changed:", files, ", lines inserted:", inserted, ", lines deleted:", deleted}'
}
