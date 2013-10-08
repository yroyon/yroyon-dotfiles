" Default xmllint indentation is 2 spaces. Set it to 4 when using '='.
"setlocal equalprg=XMLLINT_INDENT=\"\ \ \ \ \"\ xmllint\ --format\ --recover\ -

command! XMLreindent call XMLreindent()
function! XMLreindent()
    :%!xmllint --format --recover -
endfunction
