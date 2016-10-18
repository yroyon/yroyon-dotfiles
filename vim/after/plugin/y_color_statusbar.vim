" BUG when first opening vim, User3 ctermbg=black, until first keystroke.
hi! User3 ctermfg=230 cterm=none ctermbg=22
hi! link User4 StatusLine

function! Mode()
    let l:mode = mode()
    if     l:mode ==# 'n'  | return '  NORMAL  '
    elseif l:mode ==# 'i'  | return '  INSERT  '
    elseif l:mode ==# 'R'  | return '  REPLACE '
    elseif l:mode ==# 'v'  | return '  VISUAL  '
    elseif l:mode ==# 'V'  | return '  V·LINE  '
    elseif l:mode ==# '' | return '  V·BLOCK '
    else                   | return l:mode
    endif
    return ""
endfunction

" BUG getting into and out of visual mode gives a one keystroke delay
" until the color is changed. The text is changed properly though.
function! SwitchModeColor(mode)
    if     a:mode ==# 'n'  | hi User3 ctermfg=230 cterm=none ctermbg=22
    elseif a:mode ==# 'i'  | hi User3 ctermfg=232 cterm=bold ctermbg=lightblue
    elseif a:mode ==# 'R'  | hi User3 ctermfg=230 cterm=bold ctermbg=160
    elseif a:mode ==? 'v'  | hi User3 ctermfg=232 cterm=bold ctermbg=208
    elseif a:mode ==# '' | hi User3 ctermfg=232 cterm=bold ctermbg=208
    endif
    return ''
endfunction

set statusline=%{SwitchModeColor(mode())}
set statusline+=%3*%{Mode()}%4*\               " colorized mode indicator
"set statusline+=%#warningmsg#                 " TODO syntastic plugin stuff
"set statusline+=%{SyntasticStatuslineFlag()}
"set statusline+=%*
set statusline+=%f\                            " file name
set statusline+=\[                             " [
set statusline+=%{strlen(&ft)?&ft:'none'},     " filetype
set statusline+=%{&encoding},                  " encoding
set statusline+=%{&fileformat}                 " file format
set statusline+=%H%W%R%M                       " flags
set statusline+=]                              " ]
set statusline+=%=                             " right align
set statusline+=%-14.(%l/%L,%c%V%)\ %<%P       " offset

au InsertEnter  * call SwitchModeColor(mode())
au InsertChange * call SwitchModeColor(mode())
au InsertLeave  * call SwitchModeColor(mode())
" also work with Ctrl-C (no Insert* event sent by vim)
inoremap <c-c> <c-o>:hi User3 ctermfg=230 cterm=none ctermbg=22<cr><c-c>

