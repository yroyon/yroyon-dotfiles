" Show line numbers.
setlocal numberwidth=3
setlocal number

" Properly indent anonymous classes
setlocal cinoptions+=j1

" Fold Javadoc comments.
" syntax method doesn't fold javadoc comments, and folds too much the rest. (the whole class is folded by default!)
" marker method with this custom fmr folds only javadoc comments. Only one fmr at a time, no regexp.
" manual method is like marker, but allows to manually add folds using zf<movement> (by writing the fmr markers into the file!! :-( ).
setlocal foldmethod=marker fmr=/**,*/

" Open the <word_under_cursor>.java file in a split window.
map gf <C-W>f
map gc gdb<C-W>f
setlocal path+=.,
"setlocal path+=/home/dgoodwin/src/trunk/eng/satellite/java/code/src/**,
setlocal include=^#\s*import
setlocal includeexpr=substitute(v:fname,'\\.','/','g')

" Quickfix (:make and :cn).
compiler ant
setlocal makeprg=ant\ -find\ ./build.xml
setlocal efm=%A\ %#[javac]\ %f:%l:\ %m,%-Z\ %#[javac]\ %p^,%-C%.%#

" How to create abbreviations.
" Usage: in insert mode, type:    sysout"
" (the character after the abbr will be printed, hence '"' in this particular case)
iabbr sysout System.out.println(");<Left><Left><Left>
iabbr Sysout System.out.println(");<Left><Left><Left>

