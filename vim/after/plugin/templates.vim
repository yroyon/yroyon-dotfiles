" Templates: home-made solution.
" See also:
" http://code.google.com/p/lh-vim/wiki/muTemplate
" http://vim.wikia.com/wiki/Category%3aAutomated_Text_Insertion

augroup templates
    au!
    autocmd BufNewFile *.java call s:JTemplate()
augroup END

""" Java source template {{{

function! s:JTemplate()
    let relpath_noext = expand("%")
    let relpath_noext = substitute(relpath_noext, "\.java$", "", "")

    let filename = s:JTemplate_GetFilename(relpath_noext)
    let dirname  = s:JTemplate_GetDir(relpath_noext, filename)

    call s:JTemplate_Skeleton(dirname, filename)
endfunction

function! s:JTemplate_GetFilename(path)
    return substitute(a:path, "^.*\/", "", "")
endfunction

function! s:JTemplate_GetDir(name, orig)
    "let dir = getcwd() . "/" . filename
    let dir = a:name
    let dir = substitute(dir, "^src\/", "", "")
    let dir = substitute(dir, "^main\/", "", "")
    let dir = substitute(dir, "^java\/", "", "")
    let dir = substitute(dir, "\/[^\/]*$", "", "")
    let dir = substitute(dir, "\/", ".", "g")
    if dir == a:orig
        let dir = substitute(dir, "*\/", "", "")
"        let dir = getcwd()
"        let dir = substitute(dir, "^.*\/", "", "")
    endif
    return dir
endfunction

function! s:JTemplate_Skeleton(dir, filename)
    call append(0, "package " . a:dir . ";") " or expand('%:t:r')
    call append(1, "")
    call append(2, "public class " . a:filename . " {")
    call append(3, "")
    call append(4, "    public static void main(String args[]) {")
    call append(5, "    }")
    call append(6, "}")
endfunction

""" }}} end Java

