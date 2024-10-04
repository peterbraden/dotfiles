#!/usr/bin/env bash
# A smart install script


# Github codespaces {{{
if [ -n "$CODESPACES" ]; then
  echo "Setting up a dev environment inside github codespaces..."
  sh -c "$(curl -fsLS get.chezmoi.io)" -- init --apply peterbraden
fi
# }}}
