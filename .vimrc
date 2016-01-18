set number
syntax on
set tabstop=8 softtabstop=0 expandtab shiftwidth=4 smarttab
set autoindent
set cursorline
hi CursorLine   cterm=NONE ctermbg=darkgray ctermfg=white guibg=darkgray guifg=white
let &colorcolumn=join(range(81,999),",")
hi ColorColumn ctermbg=NONE ctermfg=red guibg=NONE guifg=red
