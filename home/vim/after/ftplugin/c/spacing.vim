setlocal tabstop=4      " 1 tab == 4 spaces
setlocal shiftwidth=4   " 1 indent == 4 spaces
setlocal expandtab
setlocal softtabstop=4

setlocal numberwidth=3
setlocal number         " show line numbers

" :help cinoptions-values
setlocal cinoptions+=t0     " func return types are indented on col 0 (default s)
setlocal cinoptions+=(0     " bool stmts like if (a && \<CR> b) (default 2s == 2*shiftwidth)
setlocal cinoptions+=)50    " search unclosed parens at most N lines away (default 20)
setlocal cinoptions+=*100   " search unclosed comments at most N lines away (default 70)

