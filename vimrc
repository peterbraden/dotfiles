call pathogen#infect()


" Basic Settings -------------------- {{{
set nocompatible    " Don't be compatible with vi

"""" Movement
" Work more logically with wrapped lines
noremap j gj
noremap k gk

"""" Searching and Patterns
set ignorecase          " search is case insensitive
set smartcase           " search case sensitive if caps on
set incsearch                               " show best match so far
set hlsearch                        " Highlight matches to the search

"""" Display
set background=dark         " I use dark background
set lazyredraw              " Don't repaint when scripts are running
set scrolloff=3             " Keep 3 lines below and above the cursor
set ruler                   " line numbers and column the cursor is on
set number                  " Show line numbering
set numberwidth=1           " Use 1 col + 1 space for numbers
set showcmd
set showmode
set title

" tab labels show the filename without path(tail)
set guitablabel=%N/\ %t\ %M
"""" Messages, Info, Status
set shortmess+=a                            " Use [+] [RO] [w] for modified, read-only, modified
set showcmd                     " Display what command is waiting for an operator
set ruler                       " Show pos below the win if there's no status line
set laststatus=2        " Always show statusline, even if only 1 window
set report=0            " Notify me whenever any lines have changed
set confirm                     " Y-N-C prompt if closing with unsaved changes
set vb t_vb=            " Disable visual bell!  I hate that flashing.

"""" Editing
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
set undofile

" we don't want to edit these type of files
set wildignore=*.o,*.obj,*.bak,*.exe,*.pyc,*.swp

"""" Coding
set history=100                                                 " 100 Lines of history
set showfulltag                                                 " Show more information while completing tags
filetype plugin on                                              " Enable filetype plugins
filetype plugin indent on                               " Let filetype plugins indent for me
syntax on                                                               " Turn on syntax highlighting

set t_Co=256
"let g:solarized_termcolors=256
let g:solarized_termtrans = 1
colorscheme solarized
set background=dark
" }}}

"""" Command Line
set wildmenu                                                    " Autocomplete features in the status bar

" Use Mac clipboard
set clipboard=unnamed

" Windows --------------- {{{
if exists(":tab")                                               " Try to move to other windows if changing buf
       set switchbuf=useopen,usetab
else                                                                    " Try other windows & tabs if available
               set switchbuf=useopen
endif
" }}}


" set up tags
set tags=tags;/
set tags+=$HOME/.vim/tags/python.ctags

" Folding ---------------------- {{{
set foldmethod=syntax                                   " By default, use syntax to determine folds
set foldlevelstart=99                                   " All folds open by default
" }}}

" Statusline
"set statusline=

let g:vim_json_syntax_conceal = 0

" Airline {{{
let g:airline_powerline_fonts = 1
let g:airline_section_c='%f'
let g:airline_section_z = '%c'
let g:airline_section_warning= ''
" }}}

"""" Autocommands
if has("autocmd")
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

endif

"""" Key Mappings
" bind ctrl+space for omnicompletion
inoremap <Nul> <C-x><C-o>

" Toggle the tag list bar
nmap <F4> :TlistToggle<CR>

" tab navigation (next tab) with alt left / alt right
nnoremap  <a-right>  gt
nnoremap  <a-left>   gT

" Ctrl + Arrows - Move around quickly
nnoremap  <c-up>     {
nnoremap  <c-down>   }
nnoremap  <c-right>  El
nnoremap  <c-down>   Bh

" Shift + Arrows - Visually Select text
nnoremap  <s-up>     Vk
nnoremap  <s-down>   Vj
nnoremap  <s-right>  vl
nnoremap  <s-left>   vh

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


" Arg!  I hate hitting q: instead of :q
nnoremap q: q:iq<esc>
nnoremap :W :w<esc>

" <space> toggles folds opened and closed
nnoremap <space> za

" <space> in visual mode creates a fold over the marked range
vnoremap <space> zf

" allow arrow keys when code completion window is up
inoremap <Down> <C-R>=pumvisible() ? "\<lt>C-N>" : "\<lt>Down>"<CR>

""" Abbreviations
function! EatChar(pat)
       let c = nr2char(getchar(0))
       return (c =~ a:pat) ? '' : c
endfunc


inoremap <expr> <C-Space> pumvisible() \|\| &omnifunc == '' ?
                       \ "\<lt>C-n>" :
                       \ "\<lt>C-x>\<lt>C-o><c-r>=pumvisible() ?" .
                       \ "\"\\<lt>c-n>\\<lt>c-p>\\<lt>c-n>\" :" .
                       \ "\" \\<lt>bs>\\<lt>C-n>\"\<CR>"
imap <C-@> <C-Space>

" Toggle the tag list bar
nmap <a-down> :TlistAddFiles %:p<CR>:TlistUpdate<CR>
nmap <F4> :TlistToggle<CR><a-down><CR>


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


augroup filetype_vim
    autocmd!
    autocmd FileType vim setlocal foldmethod=marker
augroup END

let mapleader = ","

" File Navigation Shortcuts {{{
" Edit files in curr folder http://vimcasts.org/episodes/the-edit-command/
cnoremap %% <C-R>=expand('%:h').'/'<cr>
noremap <leader>ew :e <C-R>=expand('%:h').'/'<cr>
noremap <leader>es :sp <C-R>=expand('%:h').'/'<cr>
noremap <leader>ev :vsp <C-R>=expand('%:h').'/'<cr>
noremap <leader>et :tabe <C-R>=expand('%:h').'/'<cr>
noremap <leader>ee :CtrlP<CR>
" }}}

set splitbelow
set splitright


"Borrowed the following from http://mrqe.co/OwAmwT
if has ('mouse')
    set mouse=a
    if &term =~ "xterm" || &term =~ "screen"
        set ttymouse=xterm2
    endif
endif

cnoreabbrev Wq wq

"  == From admc
" Highlight redundant whitespaces.
highlight RedundantSpaces ctermbg=blue guibg=blue 
match RedundantSpaces /\s\+$\| \+\ze\t/

" Cycle through the tabs
map <C-J> :tabp<CR>
map <C-K> :tabn<CR>


" Arduino
au BufRead,BufNewFile *.pde set filetype=arduino
au BufRead,BufNewFile *.ino set filetype=arduino

" Ctrl P {{{
let g:ctrlp_map = '<c-p>'
let g:ctrlp_cmd = 'CtrlP'
let g:ctrlp_custom_ignore = {
  \ 'vcs' : '\v[\/]\.(git|hg|svn|)$',
  \ 'dir': 'node_modules',
  \ }
let g:ctrlp_open_new_file = 't'
let g:ctrlp_prompt_mappings = {
  \ 'AcceptSelection("t")': ['<c-t>', '<cr>'],
  \ 'AcceptSelection("e")': [],
  \ }
" }}}

" Editing VIM {{{
" Shortcuts.vim
source $HOME/shortcuts.vim
" Open vimrc or shortcuts.vim
:nnoremap <leader>rc :vsplit $MYVIMRC<cr>
:nnoremap <leader>sc :vsplit $HOME/shortcuts.vim<cr>
" }}}
