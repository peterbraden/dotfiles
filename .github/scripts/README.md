# CI Test Scripts

This directory contains shell scripts for testing dotfiles portability across different operating systems and environments.

## Test Scripts

### `install-dependencies.sh`
Installs required dependencies for testing:
- chezmoi
- bash and zsh shells
- Basic development tools (git, tmux, vim)

Auto-detects OS via `$OSTYPE` and installs appropriate packages.

### `test-chezmoi-apply.sh`
Tests that `chezmoi apply` works without errors. Creates a minimal test configuration and applies the dotfiles.

### `test-shell-startup.sh`
Tests that shells start without critical errors. Checks both bash and zsh startup by sourcing configuration files.

Usage: `./test-shell-startup.sh [bash|zsh]`

### `test-tmux-config.sh`
Validates tmux configuration loads without errors. Creates a test session and sources the config file.

### `test-vim-config.sh`
Tests vim and neovim configurations:
- Verifies vim/nvim start with configs loaded
- Checks for critical syntax errors
- Validates plugin directories exist (submodules)

### `test-scripts-syntax.sh`
Validates shell script syntax for all scripts in `home/bin/` using `bash -n`. Skips Python scripts.

### `test-rendered-configs.sh`
Verifies that chezmoi has correctly rendered configuration files:
- Checks that config files exist and are non-empty
- Validates shell syntax of rendered configs
- Confirms scripts are installed to `~/bin`

## GitHub Actions Workflow

The `portability.yml` workflow uses a matrix strategy to test on:
- Ubuntu 22.04
- Ubuntu 24.04
- macOS latest

Adding new test environments is straightforward - just add to the matrix.

Each test run:
1. Checks out the repository with submodules
2. Auto-detects OS and installs dependencies
3. Validates script syntax
4. Applies dotfiles with chezmoi
5. Tests rendered configurations
6. Tests bash and zsh shell startup
7. Tests tmux configuration loads
8. Tests vim/neovim configuration loads

## Running Tests Locally

To test locally before pushing:

```bash
# Test script syntax
.github/scripts/test-scripts-syntax.sh

# On a test machine or container, run full suite:
export GITHUB_WORKSPACE=$PWD
.github/scripts/install-dependencies.sh  # Auto-detects OS
.github/scripts/test-chezmoi-apply.sh
.github/scripts/test-rendered-configs.sh
.github/scripts/test-shell-startup.sh bash
.github/scripts/test-shell-startup.sh zsh
.github/scripts/test-tmux-config.sh
.github/scripts/test-vim-config.sh
```

## Notes

- Tests are designed to be tolerant of missing optional tools (e.g., nvm, pyenv, cargo)
- Plugin dependencies (like zsh-autosuggestions) are included as git submodules
- The workflow uses GitHub Actions grouping (`::group::`) for better log readability
