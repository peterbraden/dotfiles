#!/usr/bin/env bash
# A smart install script

set -eu

# ---- Github codespaces ----
# Codespaces was the original motivation behind this script as it does
# some things 'strangely' and doesn't play nicely with chezmoi out of the
# box.
if [ -n "$CODESPACES" ]; then
  echo "Setting up a dev environment inside github codespaces..."
  
  # Github auth in codespaces defaults to http
  # Ref: https://docs.github.com/en/codespaces/troubleshooting/troubleshooting-authentication-to-a-repository#authenticating-to-the-repository-you-created-the-codespace-from
  git config --global url."https://github.com/".insteadOf git@github.com:

  # Codespaces clones to /workspaces/.codespaces/.persistedshare/dotfiles, but we want 
  # to install the binary to the ~/.local/bin directory
  bin_dir="$HOME/.local/bin"
 
  if ! chezmoi="$(command -v chezmoi)"; then
        chezmoi="${bin_dir}/chezmoi"
        echo "Installing chezmoi to '${chezmoi}'" >&2
        if command -v curl >/dev/null; then
                chezmoi_install_script="$(curl -fsSL get.chezmoi.io)"
        elif command -v wget >/dev/null; then
                chezmoi_install_script="$(wget -qO- get.chezmoi.io)"
        else
                echo "To install chezmoi, you must have curl or wget installed." >&2
                exit 1
        fi
        sh -c "${chezmoi_install_script}" -- -b "${bin_dir}"
        unset chezmoi_install_script bin_dir
  fi

  # POSIX way to get script's dir: https://stackoverflow.com/a/29834779/12156188
  script_dir="$(cd -P -- "$(dirname -- "$(command -v -- "$0")")" && pwd -P)"

  # The home folder you get given in codespaces isn't exactly clean to begin with. Let's clean up.
  rm -rf ~/.oh-my-zsh ~/.ruby ~/.rbenv ~/.php ~/.maven ~/.hugo ~/.conda ~/.rvmrc ~/.screenrc ~/.minikube ~/.nvs ~/.jupyter ~/.dotnet ~/.nvm ~/.java 

  # We are separately initing chezmoi - this means a _second_ clone of the dotfiles repo, outside of codespaces control
  chezmoi init --apply peterbraden

  sudo chsh "$(whoami)" --shell /usr/bin/zsh
  export SHELL=/usr/bin/zsh
fi



