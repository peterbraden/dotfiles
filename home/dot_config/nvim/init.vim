set runtimepath^=~/.vim
set runtimepath+=~/.vim/after
set runtimepath+=~/.config/neovim
let &packpath = &runtimepath
source ~/.vimrc
source ~/.config/nvim/plugins/vim-plug/plug.vim

call plug#begin('~/.config/nvim/plugins')
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim', { 'tag': '0.1.1' }
call plug#end()
