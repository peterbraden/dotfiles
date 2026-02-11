#!/usr/bin/env bash
# A smart install script

set -eu

ensure_chezmoi() {
  if ! chezmoi="$(command -v chezmoi)"; then
    local bin_dir="$HOME/.local/bin"
    mkdir -p "${bin_dir}"
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
    unset chezmoi_install_script
  fi
}


get_script_dir() {
  # POSIX way to get script's dir: https://stackoverflow.com/a/29834779/12156188
  cd -P -- "$(dirname -- "$(command -v -- "$0")")" && pwd -P
}


apply_chezmoi() {
  local source_dir="$1"
  "${chezmoi}" init --apply --force peterbraden --source "${source_dir}"
}


use_zsh() {
  if [ -x "$(command -v zsh)" ]; then
    sudo chsh "$(whoami)" --shell "$(command -v zsh)"
    export SHELL=/usr/bin/zsh
  fi
}

# ---- Github codespaces ---- {{{
# Codespaces was the original motivation behind this script as it does
# some things 'strangely' and doesn't play nicely with chezmoi out of the
# box.
if [ -n "${CODESPACES:-}" ]; then
  echo "Setting up a dev environment inside github codespaces..."

  # Github auth in codespaces defaults to http
  # Ref: https://docs.github.com/en/codespaces/troubleshooting/troubleshooting-authentication-to-a-repository#authenticating-to-the-repository-you-created-the-codespace-from
  git config --global url."https://github.com/".insteadOf git@github.com:
  #git submodule update --init --recursive
 
  # Codespaces clones to /workspaces/.codespaces/.persistedshare/dotfiles, but we want 
  # to install the binary to the ~/.local/bin directory
  ensure_chezmoi

  # The home folder you get given in codespaces isn't exactly clean to begin with. Let's clean up.
  rm -rf ~/.oh-my-zsh ~/.ruby ~/.rbenv ~/.php ~/.maven ~/.hugo ~/.conda ~/.rvmrc ~/.screenrc ~/.minikube ~/.nvs ~/.jupyter ~/.dotnet ~/.nvm ~/.java
    
  script_dir="$(get_script_dir)"
  apply_chezmoi "${script_dir}"
  use_zsh
fi
# }}}
 
#  ---- Gitpod / Ona ---- {{{
if [ -n "${GITPOD_API_URL:-}" ]; then
  echo "Setting up a dev environment inside Gitpod/Ona..."
  
  # Submodules using git@github.com: URLs need HTTPS rewrite without SSH keys
  git config --global url."https://github.com/".insteadOf git@github.com:

  ensure_chezmoi
  script_dir="$(get_script_dir)"
  git -C "${script_dir}" submodule update --init --recursive
  apply_chezmoi "${script_dir}"
  use_zsh
fi
# }}}
