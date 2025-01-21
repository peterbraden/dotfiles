set runtimepath^=~/.vim
set runtimepath+=~/.vim/after
set runtimepath+=~/.config/neovim
let &packpath = &runtimepath
source ~/.vimrc

" Find files using Telescope command-line sugar instead of ctrl-p plugin
"nnoremap <leader>ee <cmd>Telescope find_files<cr>

" :lua require'lspconfig'.ruff.setup{}
