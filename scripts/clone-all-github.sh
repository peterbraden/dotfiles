#!/bin/bash
# Usage: CLONE=true GHNAME=foo

if [ -z "$GHNAME" ]; then
  GHNAME=$(whoami)
fi

DIRECTORY=~/repos

function update_repo {
  cd $1
  git fetch --all
}

function clone_or_update {
  while read REPO; do
    REPONAME=$(echo $REPO | sed "s/.*$GHNAME\/\([0-9A-z_.-]*\).git$/\1/")
    REPODIR=$DIRECTORY/$REPONAME
    if [ -d "$REPODIR" ]; then
      echo "# --- Updating $REPODIR"
      update_repo $REPODIR
    else
      if [ -n "$CLONE" ]; then
        echo "# --- Cloning $REPODIR"
        cd $DIRECTORY
        git clone $REPO
      fi
    fi
  done
}

echo "# --- Update repos for $GHNAME"

curl -s "https://api.github.com/users/$GHNAME/repos?per_page=200" |
perl -ne 'print "$1\n" if (/"ssh_url": "([^"]+)/)' |
clone_or_update

#curl -u $GHNAME -s 'https://api.github.com/users/$GHNAME/repos?per_page=200' | perl -ne 'print "$1\n" if (/"ssh_url": "([^"]+)/)' | xargs -n 1 git clone
