#!/usr/bin/env bash
# A smart install script


# Github codespaces {{{
if [ -n "$CODESPACES" ]; then
  echo "Setting up a dev environment inside github codespaces..."

  # Github auth in codespaces defaults to http
  # Ref: https://docs.github.com/en/codespaces/troubleshooting/troubleshooting-authentication-to-a-repository#authenticating-to-the-repository-you-created-the-codespace-from
  git config --global url."https://github.com/".insteadOf git@github.com

  sh -c "$(curl -fsLS get.chezmoi.io)" -- init --apply peterbraden
fi
# }}}
