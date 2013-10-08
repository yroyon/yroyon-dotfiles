setlocal tabstop=4     " 1 tab == 4 spaces
setlocal shiftwidth=4  " 1 indent == 4 spaces
setlocal expandtab     " replace tabs with spaces
setlocal softtabstop=4 " backspace deletes 4 spaces (1 tab) instead of 1

setlocal numberwidth=3
setlocal number

"set foldmethod=indent

" Show tabs and trailing whitespace visually
if (&encoding == "utf-8")
    setlocal list listchars=tab:»·,trail:·,extends:>,nbsp:_
else
    setlocal list listchars=tab:>-,trail:.,extends:>,nbsp:_
endif
highlight WhiteSpaceEol NONE

" Comments with # are indented
inoremap # X<c-h>#

