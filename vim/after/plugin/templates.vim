" Templates: home-made solution.
" See also:
" http://code.google.com/p/lh-vim/wiki/muTemplate
" http://vim.wikia.com/wiki/Category%3aAutomated_Text_Insertion

augroup templates
    au!
    autocmd BufNewFile *.java call InsertJavaTemplate()
augroup END

function! InsertJavaTemplate()
    let filename = expand("%")
    let filename = substitute(filename, "\.java$", "", "")
    "let dir = getcwd() . "/" . filename
    let dir = filename
    let dir = substitute(dir, "^src\/", "", "")
    let dir = substitute(dir, "^main\/", "", "")
    let dir = substitute(dir, "^java\/", "", "")
    let dir = substitute(dir, "\/[^\/]*$", "", "")
    let dir = substitute(dir, "\/", ".", "g")
    let filename = substitute(filename, "^.*\/", "", "")
    call append(0, "package " . dir . ";") " or expand('%:t:r')
    call append(1, "")
    call append(2, "public class " . filename . " {")
    call append(3, "")
    call append(4, "    public static void main(String args[]) {")
    call append(5, "    }")
    call append(6, "}")
endfunction

