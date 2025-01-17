#!/usr/bin/env bash
# Open all changed files as tabs in vim.
read -a files < <(git diff --name-only | uniq | sed 's/ /\\ /g')
vim -p  $files 

