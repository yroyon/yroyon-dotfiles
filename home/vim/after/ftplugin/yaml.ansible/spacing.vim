setlocal tabstop=2
setlocal shiftwidth=2
setlocal softtabstop=2
setlocal expandtab

setlocal foldmethod=indent nofoldenable

" Skip re-indenting lines after inserting a comment (#) at the beginning of a line, or a colon.
setlocal indentkeys-=0# indentkeys-=<:>
