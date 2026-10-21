#!/usr/bin/env bash
# Single entrypoint: set up a machine from these dotfiles.
#
#   # Fresh machine
#   curl -fsSL https://raw.githubusercontent.com/peterbraden/dotfiles/master/install.sh | bash
#   # Test a branch, and pass extra arguments to `chezmoi init`
#   curl -fsSL .../install.sh | DOTFILES_BRANCH=roche2 bash -s -- --promptBool work=true
#   # From a checkout (Codespaces and Gitpod run it this way)
#   ./install.sh
#
# Only does what chezmoi can't do for itself: make git available, install
# chezmoi and hand over. Packages, toolchains and the rest are chezmoi scripts
# in home/.

set -euo pipefail

DOTFILES_REPO="peterbraden"
DOTFILES_BRANCH="${DOTFILES_BRANCH:-master}"

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

# The checkout this script lives in, or nothing when piped from curl
repo_dir() {
  local src="${BASH_SOURCE[0]:-}"
  [ -n "$src" ] && [ -f "$src" ] || return 0
  local dir
  dir="$(cd -P -- "$(dirname -- "$src")" && pwd -P)"
  [ -f "$dir/.chezmoiroot" ] && echo "$dir"
  return 0
}

# A fresh Mac's /usr/bin/git is a stub that opens a dialog, so chezmoi can't
# clone. Homebrew's installer also installs the Command Line Tools (real git).
ensure_macos_git() {
  [ "$(uname -s)" = "Darwin" ] || return 0
  if ! command -v brew >/dev/null && [ ! -x /opt/homebrew/bin/brew ] && [ ! -x /usr/local/bin/brew ]; then
    echo "Installing Homebrew (and the Command Line Tools)..." >&2
    sudo -v
    NONINTERACTIVE=1 bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  fi
  if [ -x /opt/homebrew/bin/brew ]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
  elif [ -x /usr/local/bin/brew ]; then
    eval "$(/usr/local/bin/brew shellenv)"
  fi
}

# Extra arguments go to `chezmoi init`
apply_chezmoi() {
  local dir
  dir="$(repo_dir)"
  # chezmoi asks its init questions on the terminal; without one (Codespaces,
  # Gitpod, CI) use the defaults instead of failing
  if ! (exec </dev/tty) 2>/dev/null; then
    set -- --promptDefaults "$@"
  fi
  if [ -n "$dir" ]; then
    # Running from a checkout: use it as the source
    git -C "$dir" submodule update --init --recursive
    "${chezmoi}" init --apply --force --source "$dir" "$@"
  elif "${chezmoi}" git -- rev-parse --git-dir >/dev/null 2>&1; then
    # Already set up: pull and apply
    "${chezmoi}" update --force
  else
    "${chezmoi}" init --apply --branch "${DOTFILES_BRANCH}" "$@" "${DOTFILES_REPO}"
  fi
}

use_zsh() {
  if [ -x "$(command -v zsh)" ]; then
    sudo chsh "$(whoami)" --shell "$(command -v zsh)"
    export SHELL=/usr/bin/zsh
  fi
}

# ---- Github codespaces ---- {{{
if [ -n "${CODESPACES:-}" ]; then
  echo "Setting up a dev environment inside github codespaces..."

  # Github auth in codespaces defaults to http
  # Ref: https://docs.github.com/en/codespaces/troubleshooting/troubleshooting-authentication-to-a-repository#authenticating-to-the-repository-you-created-the-codespace-from
  git config --global url."https://github.com/".insteadOf git@github.com:

  # The home folder you get given in codespaces isn't exactly clean to begin with. Let's clean up.
  rm -rf ~/.oh-my-zsh ~/.ruby ~/.rbenv ~/.php ~/.maven ~/.hugo ~/.conda ~/.rvmrc ~/.screenrc ~/.minikube ~/.nvs ~/.jupyter ~/.dotnet ~/.nvm ~/.java

  ensure_chezmoi
  apply_chezmoi "$@"
  use_zsh
  exit 0
fi
# }}}

#  ---- Gitpod / Ona ---- {{{
if [ -n "${GITPOD_API_URL:-}" ]; then
  echo "Setting up a dev environment inside Gitpod/Ona..."

  # Submodules using git@github.com: URLs need HTTPS rewrite without SSH keys
  git config --global url."https://github.com/".insteadOf git@github.com:

  ensure_chezmoi
  apply_chezmoi "$@"
  use_zsh

  # Ensure welcome-claude.sh is sourced (sets up Claude Code proxy auth)
  if command -v welcome-claude.sh >/dev/null && ! grep -q 'welcome-claude.sh' "$HOME/.zshrc" 2>/dev/null; then
    echo 'source welcome-claude.sh' >> "$HOME/.zshrc"
  fi
  exit 0
fi
# }}}

# ---- Desktop / server (macOS, Linux) ---- {{{
ensure_macos_git
ensure_chezmoi
apply_chezmoi "$@"
# }}}
