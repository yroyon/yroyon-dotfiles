" Example of linter setup using basic Vim instead of neomake/syntastic

setlocal errorformat=%f:\ line\ %l\\,\ col\ %c\\,\ %m,%-G%.%#
setlocal makeprg=jshint
autocmd! BufWritePost <buffer> silent make! % | silent redraw! | cwindow | silent wincmd p
