" Abbreviations: Insert dates / times {{{
iabbr _t  <C-R>=strftime("%H:%M:%S")<CR>
iabbr _d  <C-R>=strftime("%Y-%m-%d")<CR>
iabbr _lorem Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.
iabbr _eml peterbraden@peterbraden.co.uk

" }}}

" Spelling mistakes:  {{{
cnoreabbrev Wq wq
nnoremap q: q:iq<esc>
command! W w
" }}}

" Strip trailing whitespace
command! Whitespace %s/\s\+$//e
