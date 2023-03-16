set runtimepath^=~/.vim
set runtimepath+=~/.vim/after
set runtimepath+=~/.config/neovim
let &packpath = &runtimepath
source ~/.vimrc
source ~/.config/neovim/plugins/vim-plug/plug.vim


Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim', { 'tag': '0.1.1' }
