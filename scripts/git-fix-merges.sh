# Open all changed files as tabs in vim.
vim -p  $(git diff --name-only | uniq | sed 's/ /\\ /g' ) 
#realpath --relative-base=.)
