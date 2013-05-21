scriptencoding utf-8
"-----------------------------------------------------------
"                     terminal setup
"-----------------------------------------------------------

if (&term =~ "rxvt") || (&term =~ "xterm")
    if has('title')
        set title
    endif
    if &termencoding == ""
        set termencoding=utf-8
    endif
    " change cursor colour depending upon mode
    if exists('&t_SI')
        let &t_SI = "\<Esc>]12;lightgoldenrod\x7"
    endif
endif


"-----------------------------------------------------------
"                        settings
"-----------------------------------------------------------

set nocompatible
set history=200
set textwidth=0   " disable auto-wrapping and adding EOL

" Use secure modelines (needs securemodelines.vim)
set nomodeline
let g:secure_modelines_verbose=0
let g:secure_modelines_modelines=15

set encoding=utf-8
set fileencoding=utf-8
set fileencodings=utf-8,iso-8859-15,default

" Syntax when printing
set printoptions+=syntax:y

"set mouse=a

"set shortmess="filnxtToO"
"set shortmess="aoOtT"

" XXX Directories for swp files
"set backupdir=~/.vim/backup
"set directory=~/.vim/backup


"-----------------------------------------------------------
"                      user interface
"-----------------------------------------------------------

" F1  : run makeprg silently
" F2  : toggle folding
" F3  :
" F4  :
" F5  : trim trailing white spaces
" F6  :
" F7  : toggle cursor column highlight
" F8  : toggle cursor line highlight
" F9  :
" F10 : toggle line numbers
" F11 : toggle paste mode
" F12 :

set ruler
set laststatus=2               " bottom status bar, 2=always
set virtualedit=block          " visual block mode (ctrl-v) goes past EOL
set wildmode=list:longest,full " <Tab> completion behaviour in ex mode

" Enhance tab completion according to wildmode
set wildmenu
set wildignore+=*.o,*~,*.class,*.pyc,*.rbc,.svn,.git
" During tab completion, give those files lower priority
set suffixes+=.info,.aux,.log,.dvi,.bbl,.out,.o,.lo
set suffixes+=.in,.a

" Try to show x lines/y cols of context when scrolling
set scrolloff=3
set sidescrolloff=2

" Line numbers
set numberwidth=3
"map  <F10> :set invnumber<CR>
"imap <F10> <Esc>:set invnumber<CR>a
" Switch between absolute line numbers, relative numbers and no numbers
noremap <F10> :set <c-r>={'00':'','01':'r','10':'nor'}[&rnu.&nu]<CR>nu<CR>
inoremap <F10> <Esc>:set <c-r>={'00':'','01':'r','10':'nor'}[&rnu.&nu]<CR>nu<CR>a
" Other impls:
" " Toggle relative/absolute line numbers
" map <Leader>na :se <c-r>=&nu?"no":""<CR>nu<CR>
" map <Leader>nr :se <c-r>=&rnu?"no":""<CR>rnu<CR>
" " Or
" nnoremap <Leader>n :se <c-r>=&rnu?"":"r"<CR>nu<CR>

function! NumberToggle()
    if(&relativenumber == 1)
        set number
    else
        set relativenumber
    endif
endfunc

nnoremap <C-n> :call NumberToggle()<cr>

"autocmd InsertEnter * :set number              " TODO
"autocmd InsertLeave * :set relativenumber

" Highlight current position
map  <F8> :set invcursorline<CR>
imap <F8> <Esc>:set invcursorline<CR>a
map  <F7> :set invcursorcolumn<CR>
imap <F7> <Esc>:set invcursorcolumn<CR>a

" Make backspace delete lots of things
set backspace=indent,eol,start

" Wrap on <Left> and <Right> in all 4 modes
"set whichwrap+=<,>,[,]

map  <F1> :make!<CR><CR>
imap <F1> <Esc>:make!<CR><CR>a

" TODO statusbar
set laststatus=2
set statusline=
"set statusline+=%#warningmsg#                 " TODO syntastic plugin stuff
"set statusline+=%{SyntasticStatuslineFlag()}
"set statusline+=%*
set statusline+=%f\                            " file name
set statusline+=\[
set statusline+=%{strlen(&ft)?&ft:'none'},     " filetype
set statusline+=%{&encoding},                  " encoding
set statusline+=%{&fileformat}                 " file format
set statusline+=%H%W%R%M                       " flags
set statusline+=]
set statusline+=%=                             " right align
set statusline+=%-14.(%l,%c%V%)\ %<%P          " offset


"-----------------------------------------------------------
"                     fonts & colours
"-----------------------------------------------------------

" Highlight syntax, but only if the terminal has colours
if &t_Co > 2 || has("gui_running")
  syntax on
  set hlsearch
endif

" If the terminal is in 88 colors (urxvt default), force to 256.
" Console supports 8, looks ugly with >8.
if &t_Co == 88
    set t_Co=256
endif

" If you use the solarized vim scheme, but not the solarized Xdefaults
let g:solarized_termcolors=256

" Try to load a nice colourscheme (from ciaranm)
function! LoadColourScheme(schemes)
    let l:schemes = a:schemes . ":"
    while l:schemes != ""
        let l:scheme = strpart(l:schemes, 0, stridx(l:schemes, ":"))
        let l:schemes = strpart(l:schemes, stridx(l:schemes, ":") + 1)
        try
            exec "colorscheme" l:scheme
            break
        catch
        endtry
    endwhile
endfunction

" me like: wombat, molokai, inkpot, vibrantink, desert256, ir_black, jellybeans, lettuce
let s:schemes_gvim = "wombat256:inkpot:vibrantink:molokai:desert256:bluegreen:default"
let s:schemes_term256 = "wombatterm_y:inkpot:molokai_y:vibrantink:desert256_y:desert256:desert"
let s:schemes_term = "desert:bluegreen:darkblue"
if has('gui')
    call LoadColourScheme(s:schemes_gvim)
else
    if has("autocmd")
        autocmd VimEnter *
            \ if &t_Co == 88 || &t_Co == 256 |
            \     call LoadColourScheme(s:schemes_term256) |
            \ else |
            \     call LoadColourScheme(s:schemes_term) |
            \ endif
    else
        if &t_Co == 88 || &t_Co == 256
            call LoadColourScheme(s:schemes_term256)
        else
            call LoadColourScheme(s:schemes_term)
        endif
    endif
endif


"-----------------------------------------------------------
"                    detect filetypes
"-----------------------------------------------------------

filetype on
filetype plugin on
filetype indent on

syntax sync fromstart
"syntax sync minlines=50
"syntax sync maxlines=200


"-----------------------------------------------------------
"                indentation, tabulations
"-----------------------------------------------------------

" TODO move to cindent
" look at /usr/share/vim/<vim-version>/indent/
" put custom versions in ~/.vim/indent/
set smartindent   " others are autoindent (dumber) or cindent (smarter)

set tabstop=4     " 1 tab == x spaces
set shiftwidth=4  " 1 indent == x spaces
set shiftround    " use multiples of 'shiftwidth'
set expandtab     " write spaces instead of tabs
set softtabstop=4 " backspace deletes x spaces (1 tab) instead of 1

" TODO test
" Toggle the 'a' option (automatic formatting) in formatoptions.
"nnoremap <silent> <leader>fa :call ToggleAutoFormatting()<CR>
function! ToggleAutoFormatting()
    if &formatoptions=~'a'
        let &l:formatoptions = substitute(&fo, 'a', '', '')
        echo 'Format options: ' . &fo
    else
        let &l:formatoptions.= 'a'
        echo 'Format options: ' . &fo
    endif
endfunction

" nremap > to >gv  and < to <gv ?? (gv restores previous visual selection)
"

"-----------------------------------------------------------
"                    typos & errors
"-----------------------------------------------------------

" XXX TODO FIXME The :hi line is rendered ineffective somewhere.
"                It works if I type it in an open vim session.
"                Putting it in ~/.vim/plugin/WhiteSpaceEOL.vim is KO.
" Highlight spaces that should not be there
highlight WhiteSpaceEOL ctermfg=darkred cterm=underline
match WhiteSpaceEOL /\s\+$/
" Reverse operation is:
"highlight WhiteSpaceEol NONE

command! TrimWhiteSpace call TrimWhiteSpace()
function! TrimWhiteSpace()
    " Preparation: save last search, and cursor position.
    let l:s = @/
    let l:l = line(".")
    let l:c = col(".")
    " Do the business:
    %s/\s\+$//e
    " Clean up: restore previous search history, and cursor position
    let @/ = l:s
    call cursor(l:l, l:c)
endfunction

map  <F5> :TrimWhiteSpace<CR>
imap <F5> <Esc>:TrimWhiteSpace<CR>a

"" To use it automatically:
"autocmd FileType vim,c,cpp,java,php autocmd BufWritePre * :%s/\s\+$//e

" TODO make 'spell' use my WhiteSpaceEOL style instead of a red bgcolor for
" errors (blue for caps errors, purple for ??)

"" TODO
"highlight YTodoGroup ctermbg=green guibg=green
"highlight YTodoGroup ctermfg=darkred cterm=underline
"augroup HighlightTODO
"    autocmd!
"    autocmd WinEnter,VimEnter * :silent! call matchadd('Todo', '@todo')
"augroup END
"augroup HighlightTODO
"    autocmd!
"    autocmd WinEnter,VimEnter * :silent! call matchadd('Todo', 'TODO', -1, 24)
"augroup END
"" put that in ~/.vim/after/common_syntax.vim ?


"-----------------------------------------------------------
"                    moving around
"-----------------------------------------------------------

" Move between visible lines and not between real lines
map <silent> <Up> gk
map <silent> <Down> gj
map <silent> <home> g<home>
map <silent> <end> g<end>

"imap <silent> <Up> <C-o>gk
"imap <silent> <Down> <C-o>gj
imap <silent> <home> <C-o>g<home>
imap <silent> <end> <C-o>g<end>

" paste mode for text/code: toggle 'smart' indent
map <F11> :set invpaste<CR>
set pastetoggle=<F11>  " also work in insert mode
"" p and P to match target indentation level (instead of just preserving
"" original indent level, like with pastetoggle)
"nnoremap p p'[v']=
"nnoremap P P'[v']=
"" Alt-p and Alt-P to behave like original p and P
"nnoremap <leader>p p
"nnoremap <leader>P P

" 'ac' toggles always/auto center (vertically)
nnoremap <silent> ac :let &scrolloff=999-&scrolloff<CR>
function! ToggleAlwaysCenter()
    let &scrolloff=999-&scrolloff
endfunction
command! ToggleAlwaysCenter call ToggleAlwaysCenter()

" Q wraps paragraph lines up to col 79. See gqap and gq}
nnoremap Q gwap
" Reverse operation, to unwrap (Join) lines: J
" To split a line under the cursor:
" (normal S is covered by cc, no problem overriding it)
nnoremap S i<cr><esc><right>

" % reacts to more delimiters, such as closing XML tags
runtime! macros/matchit.vim


"-----------------------------------------------------------
"                  search and replace
"-----------------------------------------------------------

set ignorecase " make searches case-insensitive
set smartcase  " unless they contain upper-case characters

set incsearch  " show the `best match so far'

set showmatch  " briefly highlight matching parens while typing

" pressing * shouldn't take you to the next match
noremap <silent> * :let @/='\<'.expand('<cword>').'\>'<bar>:set hls<CR>
" g* searches for partial words
noremap <silent> g* :let @/=expand('<cword>')<bar>:set hls<CR>

map µ <Esc>:set invhlsearch<CR>

" center screen on search matches
nnoremap N Nzz
nnoremap n nzz
" make zz/zt/zb center blocks (instead of current line) with visual selections
vnoremap <silent> zz :<C-u>call setpos('.',[0,(line("'>")-line("'<"))/2+line("'<"),0,0])<Bar>normal! zzgv<CR>
vnoremap <silent> zt :<C-u>call setpos('.',[0,line("'<"),0,0])<Bar>normal! ztgv<CR>
vnoremap <silent> zb :<C-u>call setpos('.',[0,line("'>"),0,0])<Bar>normal! zbgv<CR>

noremap ;; :%s:::g<Left><Left><Left>


"-----------------------------------------------------------
"                        comments
"-----------------------------------------------------------

" TODO: Loses search pattern, cursor position. should restore them. see TrimWhiteSpace above.
" TODO: Move to NERDcommenter?

" single-line comments:
"map <silent> ,# :s/^/#/<CR><Esc>:nohlsearch<CR>
"       => this puts # at BOL
"map <silent> ,# :s/^\(\s\\|\t\)*/\0#/<CR><Esc>:nohlsearch<CR>
"       => this puts # at 1st non-space char

map <silent> ,# :s/^/#/<CR><Esc>:nohlsearch<CR>
map <silent> ,/ :s/^\(\s\\|\t\)*/\0\/\//<CR><Esc>:nohlsearch<CR>
map <silent> ,> :s/^/> /<CR><Esc>:nohlsearch<CR>
map <silent> ," :s/^/\"/<CR><Esc>:nohlsearch<CR>
map <silent> ,% :s/^/%/<CR><Esc>:nohlsearch<CR>
map <silent> ,! :s/^/!/<CR><Esc>:nohlsearch<CR>
map <silent> ,; :s/^/;/<CR><Esc>:nohlsearch<CR>
map <silent> ,- :s/^/--/<CR><Esc>:nohlsearch<CR>
map <silent> ,d :s/^/dnl /<CR><Esc>:nohlsearch<CR>
" uncomment (cursor anywhere in the line), keep indentation:
map <silent> ,c :s:\(^\s*\)\(//\\|--\\|> \\|[#"%!;]\\|dnl \):\1:e<CR><Esc>:nohlsearch<CR>

" multi-line comments:
" not there yet: this adds start and end comments on each selected line
map <silent> ,* :s/^\(.*\)$/\/\* \1 \*\//<CR><Esc>:nohlsearch<CR>
map <silent> ,( :s/^\(.*\)$/\(\* \1 \*\)/<CR><Esc>:nohlsearch<CR>
map <silent> ,< :s/^\(.*\)$/<!-- \1 -->/<CR><Esc>:nohlsearch<CR>
" uncomment (cursor anywhere in the line), keep indentation:
map <silent> ,u :s:\(^\s*\)\([/(]\*\\|<!--\) \(.*\) \(\*[/)]\\|-->\)$:\1\3:e<CR><Esc>:nohlsearch<CR>


"-----------------------------------------------------------
"                      normal mode
"-----------------------------------------------------------

" Spacebar creates spaces in normal mode:
map <Space> i<Space><Esc>l

" Incrementing (ctrl-a, ctrl-x) accepts decimal, hexa and chars (but not octal)
set nrformats="alpha,hex"

" Invoke sudo to write into current open file
command! W w !sudo tee > /dev/null %


"-----------------------------------------------------------
"               completion in insert mode (FIXME)
"-----------------------------------------------------------

" XXX
set dictionary=/usr/share/dict/words

" Show full tags when doing search completion (works only moderately well)
set showfulltag

" Ctrl-Space in insert mode opens completion window
inoremap <Nul> <C-x><C-o>

"set completeopt+=longest
set completeopt+=menuone,preview

imap     <expr> <Down>     pumvisible()?"\<C-N>":"\<C-o>gj"
imap     <expr> <Up>       pumvisible()?"\<C-P>":"\<C-o>gk"
inoremap <expr> <PageDown> pumvisible()?"\<PageDown>\<C-P>\<C-N>":"\<PageDown>"
inoremap <expr> <PageUp>   pumvisible()?"\<PageUp>\<C-P>\<C-N>":"\<PageUp>"

inoremap <expr> <CR>       pumvisible()?"\<C-Y>":"\<CR>"
"inoremap <expr> <Esc>      pumvisible()?"\<C-E>":"\<Esc>"

function! CleverTab()
    if pumvisible()
        return "\<C-N>"
    endif
    if strpart(getline('.'), 0, col('.') - 1) =~ '^\s*$'
        return "\<Tab>"
    elseif exists('&omnifunc') && &omnifunc != ''
        return "\<C-X>\<C-O>"
    else
        return "\<C-N>"
    endif
endfunction

"inoremap <Tab> <C-R>=CleverTab()<CR>
"inoremap <S-Tab> <C-P>
"inoremap <expr> <Tab> CleverTab()
inoremap <expr> <Tab> pumvisible()?"<C-R>=CleverTab()\<CR>":"\<Tab>"


"-----------------------------------------------------------
"                          ctags
"-----------------------------------------------------------

command! TagRenew call RenewCtags()

" FIXME I don't use that, it sucks.
"  -> Call ctags directly instead of using make.
"  -> Should I force creation of tags file? (have 2 functions?)
"  -> Way to add "system" tags files, for Java, Python etc. Through env, like
"  below for cscope?
"
" Re-create a tags file.
" 1) vim must be run from the location of the current tags file
" 2) this location must contain a Makefile with a 'tags' target
function! RenewCtags()
    if filereadable("./tags")
        silent !make tags
        redraw!
        set tags=tags
    else
        echohl WarningMsg | echo "failed to run 'make tags' in " $PWD | echohl None
    endif
endfunction

" Shortcuts:
" Ctrl-]   Goes to function declaration (signature)
"            Same as :tag
" g-]      Goes to function definition (implementation)
"            Same as :ts


"-----------------------------------------------------------
"                          cscope
"-----------------------------------------------------------

if has("cscope")
    set csprg=cscope
    set csto=0
    " Make :tag, Ctrl-] etc use cscope+ctags instead of just ctags
    "set cst
    set nocsverb
    " Add any database in current directory
    if filereadable("cscope.out")
        cs add cscope.out
    endif
    " Add database pointed to by environment
    if $CSCOPE_DB != ""
        cs add $CSCOPE_DB
    endif
    set csverb
endif

"map <C-}> :cstag <C-R>=expand("<cword>")<CR><CR>  " => same as <C-]>
map <silent> g[ :cs find 3 <C-R>=expand("<cword>")<CR><CR>


"-----------------------------------------------------------
"                   app-specific settings
"-----------------------------------------------------------
"   (Those generally must be in .vimrc, not under .vim/)

" Assume the shell is Bash (:help sh.vim)
let g:is_bash=1

let g:c_gnu=1

" For clang-complete
"let g:clang_use_library = 1

" Default .tex to LaTeX instead of ConTeXt
let g:tex_flavor = "latex"

" Java : do not highlight 'delete' and such as errors.
let g:java_allow_cpp_keywords = 0
" Num of previous lines used to synchronize highlighting (default 10)
"let java_minlines = 50

" Haskellmode  http://projects.haskell.org/haskellmode-vim
" let haskell_indent_case=4 " (default 5)
" let haskell_indent_if=2   " (default 3)
" let g:haddock_browser="/usr/bin/elinks"
" let g:haddock_browser_callformat="%s file://%s >/dev/null 2>&1 &"
" au BufEnter *.hs compiler ghc

" Haskell conceal  https://github.com/Twinside/vim-haskellConceal
" TODO Disable for now: bg color is ugly, I have to change it, like so:
"   hi conceal ctermfg=DarkBlue ctermbg=none guifg=DarkBlue guibg=none
let g:no_haskell_conceal = 1

let g:haddock_browser="/usr/bin/firefox"

" :TOhtml
let g:html_number_lines=1  " 0/1, don't/show line numbers
let g:html_use_css=1
let g:use_xhtml=1

" Help files: make <Return> behave like <C-]> (jump to tag)
autocmd FileType help nmap <buffer> <Return> <C-]>

" Additional file extensions
augroup y_extrafileexts
    au!
    au BufRead,BufNewFile *.pom                  setfiletype xml
    au BufRead,BufNewFile *.scala                setfiletype scala
augroup END

augroup y_modeline
try
    autocmd Syntax *
            \ syn match VimModelineLine /^.\{-1,}vim:[^:]\{-1,}:.*/ contains=VimModeline |
            \ syn match VimModeline contained /vim:[^:]\{-1,}:/
    hi def link VimModelineLine comment
    hi def link VimModeline     special
catch
endtry
augroup END

" Compressed files
augroup lzma
    au!
    au BufReadPre,FileReadPre       *.lzma setlocal bin
    au BufReadPost,FileReadPost     *.lzma call gzip#read("lzma -d")
    au BufWritePost,FileWritePost   *.lzma call gzip#write("lzma")
    au FileAppendPre                *.lzma call gzip#appre("lzma -d")
    au FileAppendPost               *.lzma call gzip#write("lzma")
augroup END

" Large files: do not highlight, swap, buffer in memory, write, or support undo
" A file is considered large if bigger than 10 MiB
let g:LargeFile = 1024 * 1024 * 10
augroup LargeFile
    autocmd BufReadPre * let f=expand("<afile>") |
        \ if getfsize(f) > g:LargeFile           |
        \     set eventignore+=FileType          |
        \     setlocal noswapfile bufhidden=unload buftype=nowrite undolevels=-1 |
        \ else                                   |
        \     set eventignore-=FileType          |
        \ endif
augroup END


"-----------------------------------------------------------
"                       hex editing
"-----------------------------------------------------------

" vim -b : edit binary using xxd-format
augroup Binary
    au!
    au BufReadPre *.bin,*.hex setlocal binary
    au BufReadPost * if &binary | exe "Hexmode" | endif
    au BufWritePre *
          \ if exists("b:editHex") && b:editHex && &binary |
          \     exe "%!xxd -r"  |
          \ endif
    au BufWritePost *
          \ if exists("b:editHex") && b:editHex && &binary |
          \     exe "%!xxd"     |
          \     exe "set nomod" |
          \ endif
augroup END

command! Hexmode call ToggleHex()
function! ToggleHex()
    " Hex mode should be considered a read-only operation.
    " Save modified and read-only flags for restoration later,
    " and clear the read-only flag for now.
    let l:modified=&mod
    let l:oldreadonly=&readonly
    let &readonly=0
    if !exists("b:editHex") || !b:editHex
        " Save old options
        let b:oldft=&ft
        let b:oldbin=&bin
        " Set new options
        setlocal binary " Make sure it overrides any textwidth, etc.
        let &ft="xxd"
        " Set status
        let b:editHex=1
        " Switch to hex editor
        %!xxd
    else
        " Restore old options
        let &ft=b:oldft
        if !b:oldbin
            setlocal nobinary
        endif
        " Set status
        let b:editHex=0
        " Return to normal editing
        %!xxd -r
    endif
    " Restore values for modified and read only state
    let &mod=l:modified
    let &readonly=l:oldreadonly
endfunction


"-----------------------------------------------------------
"                           misc
"-----------------------------------------------------------

set grepprg=grep\ -nH\ $*

" Toggle the NERD_tree plugin
"map <leader>d :execute 'NERDTreeToggle ' . getcwd()<CR>


try
    call pathogen#helptags()
    call pathogen#runtime_append_all_bundles()
catch
endtry


" -------------------------
" shortcuts you should know:
" -------------------------
"
" Ctrl-A and Ctrl-X   to increment/decrement
" Ctrl-N and Ctrl-P   to auto-complete (ins mode)
"
" K    to reach the man page for the current word
" g Ctrl-G       to count words
" \i<CR>         to split a line at the cursor's position (similar to S)
"
" gd,  gD        go to var definition (local/global)
" *,  g*         search (exact word/containing word)
"
" :Explore,  :Ex,  :n .   to explore the opened file's directory
" :retab                  to convert tabs to spaces
"
" In Insert mode: Ctrl-R=<some simple math like 2+2><CR>
"
" Copy-paste integration:
"   visual mode (V or Ctrl-V), highlight text,  ?+y
"   now the text is in the standard (X? OS?) clipboard.
"
"   Pasting from OS clipboard into Vim:  ?+gP
"
