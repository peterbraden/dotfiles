" Abbreviations: Insert dates / times {{{
iabbr _t  <C-R>=strftime("%H:%M:%S")<CR><C-R>=EatChar('\s')<CR>
iabbr _d  <C-R>=strftime("%a, %d %b %Y")<CR><C-R>=EatChar('\s')<CR>
iabbr _dt <C-R>=strftime("%a, %d %b %Y %H:%M:%S %z")<CR><C-R>=EatChar('\s')<CR>
" }}}

" Spelling mistakes:  {{{
cnoreabbrev Wq wq
nnoremap q: q:iq<esc>
nnoremap :W :w<esc>
" }}}
