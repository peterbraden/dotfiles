set runtimepath^=~/.vim
set runtimepath+=~/.vim/after
set runtimepath+=~/.config/neovim
let &packpath = &runtimepath
source ~/.vimrc
source ~/.config/nvim/vim-plug/plug.vim

call plug#begin('~/.config/nvim/plugins')
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim', { 'tag': '0.1.1' }
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
Plug 'nvim-lspconfig'
call plug#end()


" Find files using Telescope command-line sugar instead of ctrl-p plugin
"nnoremap <leader>ee <cmd>Telescope find_files<cr>

:lua require'lspconfig'.ruff.setup{}
