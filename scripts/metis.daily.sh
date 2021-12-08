NOTES_DIR="/home/peterbraden/Dropbox"

notes_stats () {
  cd $NOTES_DIR

  total=0
  for sha in $(git rev-list --since="6am" --abbrev-commit master | sed -e '$ d'); do
    added=$(git diff --word-diff=porcelain $sha~1..$sha|grep -e"^+[^+]"|wc -w|xargs)
    deleted=$(git diff --word-diff=porcelain $sha~1..$sha|grep -e"^-[^-]"|wc -w|xargs)
    duplicated=$(git diff $sha~1..$sha|grep -e"^+[^+]" -e"^-[^-]"|sed -e's/.//'|sort|uniq -d|wc -w|xargs)
    date=$(git show --no-patch --no-notes --pretty='%ci' $sha | cut -c1-16)
    prefix="- $sha $date :"
    total=$((total+added))
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
    echo "Total words added:", $total
    git log --shortstat --since="1 day ago" | grep "files changed" | awk '{files+=$1; inserted+=$4; deleted+=$6} END {print "Files changed:", files, ", lines inserted:", inserted, ", lines deleted:", deleted}'
}

notes_stats
