" Abbreviations: Insert dates / times {{{
iabbr _t  <C-R>=strftime("%H:%M:%S")<CR>
iabbr _d  <C-R>=strftime("%Y-%m-%d")<CR>
" }}}

" Spelling mistakes:  {{{
cnoreabbrev Wq wq
nnoremap q: q:iq<esc>
nnoremap :W :w<esc>
" }}}

