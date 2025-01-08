#!/usr/bin/env bash
# A smart install script


# Github codespaces {{{
if [ -n "$CODESPACES" ]; then
  echo "Setting up a dev environment inside github codespaces..."
  
  # Github auth in codespaces defaults to http
  # Ref: https://docs.github.com/en/codespaces/troubleshooting/troubleshooting-authentication-to-a-repository#authenticating-to-the-repository-you-created-the-codespace-from
  git config --global url."https://github.com/".insteadOf git@github.com:

  # Codespaces clones to /workspaces/.codespaces/.persistedshare/dotfiles, but we want 
  # to install the binary to the ~/.local/bin directory
  bin_dir="$HOME/.local/bin"
  sh -c "$(curl -fsLS get.chezmoi.io)" -- -b "$bin_dir" init --apply peterbraden

  sudo chsh "$(whoami)" --shell /usr/bin/zsh
  export SHELL=/usr/bin/zsh
fi
# }}}
