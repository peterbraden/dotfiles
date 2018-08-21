#!/bin/bash
SESSION=$1
DIRECTORY=~/repos/$SESSION
SESSION_NO_DOTS=${SESSION//\./-}

if tmux info &> /dev/null && tmux has-session -t $SESSION_NO_DOTS; then
  echo "reattaching to $SESSION_NO_DOTS"
  tmux attach -t $SESSION_NO_DOTS
  exit 2
fi


if [ ! -d "$DIRECTORY" ]; then
  cd ~/repos
  git clone git@github.com:peterbraden/$SESSION
fi

echo "starting new session $SESSION_NO_DOTS $DIRECTORY"
tmux new-session -s $SESSION_NO_DOTS -c $DIRECTORY -d

tmux new-window -t $SESSION_NO_DOTS:1 -c $DIRECTORY
tmux new-window -t $SESSION_NO_DOTS:2 -c $DIRECTORY
tmux select-window -t $SESSION_NO_DOTS:0
tmux send-keys "~/repos/dotfiles/motd" C-m

tmux attach-session -t $SESSION_NO_DOTS


