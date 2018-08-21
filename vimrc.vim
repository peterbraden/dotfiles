set nocp
call pathogen#infect()
let mapleader = ","

" Basic Settings -------------------- {{{
set nocompatible    " Don't be compatible with vi
set history=100         " 100 Lines of history
set showfulltag         " Show more information while completing tags
filetype on
filetype plugin on      " Enable filetype plugins
filetype plugin indent on           " Let filetype plugins indent for me
" Use Mac clipboard
set clipboard=unnamed

"Disable Ex Mode
nnoremap Q <nop>

" }}}

" Searching and Patterns ------------ {{{
set ignorecase          " search is case insensitive
set smartcase           " search case sensitive if caps on
set incsearch           " show best match so far
set hlsearch            " Highlight matches to the search
" }}}

" Backups / Swapfiles etc ------------ {{{
set nobackup
set nowritebackup
set noswapfile
set undofile
set undodir=~/.vimundo/
" }}}

" Display -------------- {{{
syntax on               " Turn on syntax highlighting
set background=dark         " I use dark background
set lazyredraw              " Don't repaint when scripts are running
set ttyfast
set scrolloff=3             " Keep 3 lines below and above the cursor
set ruler                   " line numbers and column the cursor is on
set number                  " Show line numbering
set numberwidth=1           " Use 1 col + 1 space for numbers
set showmode
set title
set guitablabel=%N/\ %t\ %M     " tab labels show the filename without path(tail)
set shortmess+=a                " Use [+] [RO] [w] for modified, read-only, modified
set showcmd                     " Display what command is waiting for an operator
set laststatus=2        " Always show statusline, even if only 1 window
set report=0            " Notify me whenever any lines have changed
set confirm             " Y-N-C prompt if closing with unsaved changes
set vb t_vb=            " Disable visual bell!  I hate that flashing.
set t_Co=256
"let g:solarized_termcolors=256
let g:solarized_termtrans = 1
colorscheme solarized
set background=dark
set textwidth=80
set colorcolumn=+1
" }}}

" Editing ------------- {{{
set backspace=2         " Backspace over anything! (Super backspace!)
set showmatch           " Briefly jump to the previous matching paren
set matchtime=2         " For .2 seconds
set formatoptions-=tc   " I can format for myself, thank you very much
set expandtab           " Use soft tabs
set tabstop=2           " Tab stop of 2
set shiftwidth=2        " sw 2 spaces (used on auto indent)
set softtabstop=2       " 2 spaces as a tab for bs/del
set autoindent
set encoding=utf-8
set hidden


" we don't want to edit these type of files
set wildignore=*.o,*.obj,*.bak,*.exe,*.pyc,*.swp
set wildignore+=*/.git/*,*/tmp/*,*.swp
" }}}

" Command Line {{{
set wildmenu                                                    " Autocomplete features in the status bar
" }}}

" Windows  {{{
if exists(":tab")                 " Try to move to other windows if changing buf
  set switchbuf=useopen,usetab
else                              " Try other windows & tabs if available
  set switchbuf=useopen
endif
" }}}

" Folding ----------------------{{{
set foldmethod=syntax     " By default, use syntax to determine folds
set foldlevelstart=99     " All folds open by default

augroup filetype_vim_fold
    autocmd!
    autocmd FileType vim setlocal foldmethod=marker
    autocmd FileType vim setlocal foldlevelstart=0     " All folds closed
    autocmd FileType vim setlocal foldlevel=0     " For files that are opened (when you first load vim, the file is open before this is called)
augroup END

" <space> toggles folds opened and closed
nnoremap <space> za
" <space> in visual mode creates a fold over the marked range
vnoremap <space> zf
" }}}

" Navigate within File {{{

" Work more logically with wrapped lines
noremap j gj
noremap k gk

" }}}

" Navigate files and directories --------------------------------------------{{{
" Edit files in curr folder http://vimcasts.org/episodes/the-edit-command/
cnoremap %% <C-R>=expand('%:h').'/'<cr>
noremap <leader>ew :e <C-R>=expand('%:h').'/'<cr>
noremap <leader>es :sp <C-R>=expand('%:h').'/'<cr>
noremap <leader>ev :vsp <C-R>=expand('%:h').'/'<cr>
noremap <leader>et :tabe <C-R>=expand('%:h').'/'<cr>
noremap <leader>ee :CtrlP<CR>
" }}}

" Navigate splits and tabs {{{
set splitbelow
set splitright

" Cycle through the tabs
map <C-J> :tabp<CR>
map <C-K> :tabn<CR>

" tab navigation (next tab) with alt left / alt right
nnoremap  <a-right>  gt
nnoremap  <a-left>   gT
" }}}

" Airline {{{
let g:airline_powerline_fonts = 1
let g:airline_section_c='%f'
let g:airline_section_z = '%c'
let g:airline_section_warning= ''
" }}}

" Transparent editing of GnuPG-encrypted files {{{
" Based on a solution by Wouter Hanegraaff
augroup encrypted
  au!

  " First make sure nothing is written to ~/.viminfo while editing
  " an encrypted file.
  autocmd BufReadPre,FileReadPre *.gpg,*.asc set viminfo=
  " We don't want a swap file, as it writes unencrypted data to disk.
  autocmd BufReadPre,FileReadPre *.gpg,*.asc set noswapfile
  " Switch to binary mode to read the encrypted file.
  autocmd BufReadPre,FileReadPre *.gpg set bin
  autocmd BufReadPre,FileReadPre *.gpg,*.asc let ch_save = &ch|set ch=2
  autocmd BufReadPost,FileReadPost *.gpg,*.asc
    \ '[,']!sh -c 'gpg --decrypt 2> /dev/null'
  " Switch to normal mode for editing
  autocmd BufReadPost,FileReadPost *.gpg set nobin
  autocmd BufReadPost,FileReadPost *.gpg,*.asc let &ch = ch_save|unlet ch_save
  autocmd BufReadPost,FileReadPost *.gpg,*.asc
    \ execute ":doautocmd BufReadPost " . expand("%:r")

  " Convert all text to encrypted text before writing
  autocmd BufWritePre,FileWritePre *.gpg set bin
  autocmd BufWritePre,FileWritePre *.gpg
    \ '[,']!sh -c 'gpg --default-recipient-self -e 2>/dev/null'
  autocmd BufWritePre,FileWritePre *.asc
    \ '[,']!sh -c 'gpg --default-recipient-self -e -a 2>/dev/null'
  " Undo the encryption so we are back in the normal text, directly
  " after the file has been written.
  autocmd BufWritePost,FileWritePost *.gpg,*.asc u
augroup END
" }}}

" Mouse {{{
"Borrowed the following from http://mrqe.co/OwAmwT
if has ('mouse')
    set mouse=a
    if &term =~ "xterm" || &term =~ "screen"
        set ttymouse=xterm2
    endif
endif
" }}}

" Editor Misc {{{

" Statusline
"set statusline=

" Paste doesn't yank
xnoremap p "_dP

let g:vim_json_syntax_conceal = 0


augroup vimrcEx
  au!
   " In all files, try to jump back to the last spot cursor was in before exiting
   au BufReadPost *
           \ if line("'\"") > 0 && line("'\"") <= line("$") |
           \   exe "normal g`\"" |
           \ endif
   " kill calltip window if we move cursor or leave insert mode
   au CursorMovedI * if pumvisible() == 0|pclose|endif
   au InsertLeave * if pumvisible() == 0|pclose|endif
augroup END

if &diff
" easily handle diffing
  vnoremap < :diffget<CR>
  vnoremap > :diffput<CR>
else
" visual shifting (builtin-repeat)
  vnoremap < <gv
  vnoremap > >gv
endif


" <C-l> redraws the screen and removes any search highlighting.
nnoremap <silent> <C-l> :nohl<CR><C-l>

"  == From admc
" Highlight redundant whitespaces.
highlight RedundantSpaces ctermbg=blue guibg=blue 
match RedundantSpaces /\s\+$\| \+\ze\t/
" }}}

" Filetypes {{{
" Arduino
augroup vimrcFiletypes
  autocmd!

  au BufRead,BufNewFile *.pde set filetype=arduino
  au BufRead,BufNewFile *.ino set filetype=arduino

  " Enable spellchecking for Markdown
  autocmd FileType markdown setlocal spell

  " Automatically wrap at 80 characters for Markdown
  autocmd BufRead,BufNewFile *.md setlocal textwidth=80

  " Automatically wrap at 72 characters and spell check git commit messages
  autocmd FileType gitcommit setlocal textwidth=72
  autocmd FileType gitcommit setlocal spell

  " Allow stylesheets to autocomplete hyphenated words
  autocmd FileType css,scss,sass setlocal iskeyword+=-

  " Treat <li> and <p> tags like the block tags they are
  let g:html_indent_tags = 'li\|p'

augroup END

" }}}

" Ctrl P {{{
let g:ctrlp_map = '<c-p>'
let g:ctrlp_cmd = 'CtrlP'
let g:ctrlp_user_command = ['.git/', 'git --git-dir=%s/.git ls-files -oc --exclude-standard', 'find %s -type f']
let g:ctrlp_custom_ignore = {
  \ 'vcs' : '\v[\/]\.(git|hg|svn|)$',
  \ 'dir': 'node_modules',
  \ }
let g:ctrlp_open_new_file = 't'
let g:ctrlp_prompt_mappings = {
  \ 'AcceptSelection("t")': ['<c-t>', '<cr>'],
  \ 'AcceptSelection("e")': [],
  \ }

if executable('rg')
  set grepprg=rg\ --color=never
  let g:ctrlp_user_command = 'rg %s --files --color=never --glob ""'
  let g:ctrlp_use_caching = 0
endif

" }}}

" Editing VIM {{{
" Shortcuts.vim
source $HOME/shortcuts.vim
" Open vimrc or shortcuts.vim
:nnoremap <leader>rc :vsplit $MYVIMRC<cr>
:nnoremap <leader>sc :vsplit $HOME/shortcuts.vim<cr>
" }}}
