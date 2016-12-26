#!/bin/bash
SESSION=$1
DIRECTORY=~/repos/$SESSION

if tmux info &> /dev/null && tmux has-session -t $SESSION; then
  echo "reattaching to $SESSION"
  tmux attach -t $SESSION
  exit 2
fi

echo "starting new session $SESSION $DIRECTORY"
tmux new-session -s $SESSION -c $DIRECTORY -d

tmux new-window -t $SESSION:1 -c $DIRECTORY
tmux new-window -t $SESSION:2 -c $DIRECTORY
tmux select-window -t $SESSION:0
tmux send-keys "~/repos/dotfiles/motd" C-m

tmux attach-session -t $SESSION


