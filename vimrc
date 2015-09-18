scriptencoding utf-8

" F1  : run makeprg silently
" F2  : git: toggle diff highlight
" F3  : git: go to next hunk
" F4  : toggle Tagbar
" F5  : trim trailing white spaces
" F6  :
" F7  : toggle cursor column highlight
" F8  : toggle cursor line highlight
" F9  :
" F10 : toggle line numbers
" F11 : toggle paste mode
" F12 :

"-----------------------------------------------------------
"                     terminal setup {{{
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

if (&termencoding ==# 'utf-8' || &encoding ==# 'utf-8') && version >= 700
    let &listchars = "tab:\u21e5\u00b7,trail:\u2423,extends:\u21c9,precedes:\u21c7,nbsp:\u26ad"
    let &fillchars = "vert:\u259a,fold:\u00b7"
else
    set listchars=tab:>\ ,trail:-,extends:>,precedes:<
endif

" prevents delays on statusbar color changes triggered by mode change
set ttimeoutlen=50
set timeoutlen=500

" }}}
"-----------------------------------------------------------

"-----------------------------------------------------------
"                        settings {{{
"-----------------------------------------------------------

set nocompatible

set encoding=utf-8
"set fileencoding=utf-8
"set fileencodings=utf-8,iso-8859-15,default

set history=50
set textwidth=0   " disable auto-wrapping and adding EOL
set viminfo='100,<50,s10,h

" Use secure modelines (needs securemodelines.vim)
set nomodeline
let g:secure_modelines_verbose=0
let g:secure_modelines_modelines=15

" Syntax when printing
set printoptions+=syntax:y

"set mouse=a

"set shortmess="filnxtToO"
"set shortmess="aoOtT"

" XXX Directories for swp files
"set backupdir=~/.vim/backup
"set directory=~/.vim/backup

" }}}
"-----------------------------------------------------------

"-----------------------------------------------------------
"                      user interface {{{
"-----------------------------------------------------------

set ruler
set laststatus=2               " bottom status bar, 2=always
set virtualedit=block          " visual block mode (ctrl-v) goes past EOL
set wildmode=list:longest,full " <Tab> completion behaviour in ex mode
set wildmenu
set wildignore+=*.o,*~,*.class,*.pyc,*.rbc,.svn,.git,tags
" During tab completion, give those files lower priority
set suffixes=.info,.aux,.log,.dvi,.bbl
set suffixes+=.in,.a,.out,.o,.lo
set suffixes+=tags

" Try to show x lines/y cols of context when scrolling
set scrolloff=3
set sidescrolloff=2

" Line numbers
set numberwidth=3
"map  <F10> :set invnumber<CR>
"imap <F10> <Esc>:set invnumber<CR>a
" Switch between absolute line numbers, relative numbers and no numbers
noremap <F10> :set <c-r>={'00':'','01':'r','10':'nor','11':'nornu no'}[&rnu.&nu]<CR>nu<CR>
inoremap <F10> <Esc>:set <c-r>={'00':'','01':'r','10':'nor','11':'nornu no'}[&rnu.&nu]<CR>nu<CR>a
" Other impls:
" " Toggle relative/absolute line numbers
" map <Leader>na :se <c-r>=&nu?"no":""<CR>nu<CR>
" map <Leader>nr :se <c-r>=&rnu?"no":""<CR>rnu<CR>
" " Or
" nnoremap <Leader>n :se <c-r>=&rnu?"":"r"<CR>nu<CR>

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

" https://github.com/mhinz/vim-startify
let g:startify_list_order = ['files', 'dir', 'bookmarks', 'sessions']
let g:startify_bookmarks  = ['~/.vimrc', '~/.bashrc', '~/TODO']
let g:startify_skiplist   = ['.*.swp']
let g:startify_files_number   = 5
let g:startify_enable_special = 1

" Status Bar
set laststatus=2
set statusline=
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
set statusline+=%-14.(%l/%L,%c%)\ %<%P         " offset

" More statusbar, incl. patched fonts
"
" https://github.com/bling/vim-airline
let g:airline_powerline_fonts = 1
"
" https://github.com/powerline/
if has('gui_macvim')
    let g:Powerline_symbols = 'fancy'
"    set guifont=DejaVu\ Sans\ Mono\ for\ Powerline:h13
"    set guifont=Droid\ Sans\ Mono\ Slashed\ for\ Powerline:h12
"    set guifont=Inconsolata\ for\ Powerline:h13
"    set guifont=Meslo\ LG\ S\ for\ Powerline:h13
    set guifont=Source\ Code\ Pro\ for\ Powerline:h13
endif

" Focus back to Mac's Terminal on exit (macvim configured to keep running in bg).
" Really not robust.
if has("gui_macvim")
    autocmd VimLeave * :!open -a iTerm
endif

" }}}
"-----------------------------------------------------------

"-----------------------------------------------------------
"                     fonts & colours {{{
"-----------------------------------------------------------

" Highlight syntax, but only if the terminal has colours
if &t_Co > 2 || has("gui_running")
  syntax on
  set hlsearch
endif

" If the terminal is in 88 colors (urxvt default), force to 256.
" Console supports 8, looks ugly with >8.
if &t_Co == 88 || (&term =~ "xterm")
    set t_Co=256
endif

" If you use the solarized vim scheme, but not the solarized Xdefaults
let g:solarized_termcolors=256
" If you use molokai from https://github.com/tomasr/molokai/
let g:rehash256 = 1

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
let s:schemes_gvim = "wombat256:luna:inkpot:vibrantink:molokai:desert256:bluegreen:default"
let s:schemes_term256 = "wombat_y:luna-term:inkpot:molokai_y:vibrantink:desert256_y:desert256:desert"
let s:schemes_term = "desert:bluegreen:darkblue"
let s:schemes_diff = "wombat_y:molokai_y:luna-term:lettuce:jellybeans"
if has('gui')
    call LoadColourScheme(s:schemes_gvim)
else
    " I had the autocmd commented out on devious. Why?
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

if &diff
    " TODO luna-term drops syntax coloring inside the diff sections.
    " Otherwise, its diff colors are nicely clear.
    call LoadColourScheme(s:schemes_diff)
endif
" }}}
"-----------------------------------------------------------

"-----------------------------------------------------------
"                    detect filetypes {{{
"-----------------------------------------------------------
filetype on
filetype plugin on
filetype indent on

syntax sync fromstart
"syntax sync minlines=50
"syntax sync maxlines=200
" }}}
"-----------------------------------------------------------

"-----------------------------------------------------------
"                        folding {{{
"-----------------------------------------------------------
set foldenable
set foldmethod=marker
set foldminlines=3
set foldnestmax=3

" When folded, show a nice line with header, nr of lines, % of file being folded.
function! NeatFoldText()
    let line = ' ' . substitute(getline(v:foldstart), '^\s*"\?\s*\|\s*"\?\s*{{' . '{\d*\s*', '', 'g') . ' '
    let lines_count = v:foldend - v:foldstart + 1
    let lines_count_text = '|' . printf("%10s", lines_count . ' lines')
    let foldchar = matchstr(&fillchars, 'fold:\zs.')
    let foldtextstart = strpart('+' . repeat(foldchar, v:foldlevel*2) . line, 0, (winwidth(0)*2)/3)
    let foldtextend = lines_count_text
    let foldtextlength = strlen(substitute(foldtextstart . foldtextend, '.', 'x', 'g')) + &foldcolumn
    let foldpercent = printf(" | %.1f", (foldtextlength*1.0)/line("$")*100) . "% "
    return foldtextstart . repeat(foldchar, winwidth(0)-foldtextlength-strwidth(foldpercent)-3) . foldtextend . foldpercent
endfunction

set foldtext=NeatFoldText()
" }}}
"-----------------------------------------------------------

"-----------------------------------------------------------
"                indentation, tabulations {{{
"-----------------------------------------------------------

" TODO check https://github.com/tpope/vim-sleuth as a dynamic way to
" auto-generate these settings

" TODO move to cindent
" look at /usr/share/vim/<vim-version>/indent/
" put custom versions in ~/.vim/indent/
set smartindent   " others are autoindent (dumber) or cindent (smarter)

set tabstop=4     " 1 tab == x spaces
set shiftwidth=4  " 1 indent == x spaces
set shiftround    " use multiples of 'shiftwidth'
set expandtab     " write spaces instead of tabs
set softtabstop=4 " backspace deletes x spaces (1 tab) instead of 1
set smarttab

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

" Keep visual selections when indenting text
vnoremap <M-<> <gv
vnoremap <M->> >gv
vnoremap <Space> I<Space><Esc>gv

" TODO try
"" p and P to match target indentation level (instead of just preserving
"" original indent level, like with pastetoggle)
"nnoremap p p'[v']=
"nnoremap P P'[v']=
"" Alt-p and Alt-P to behave like original p and P
"nnoremap <leader>p p
"nnoremap <leader>P P

" }}}
"-----------------------------------------------------------

"-----------------------------------------------------------
"                    typos & errors {{{
"-----------------------------------------------------------

let g:spellfile_URL = 'http://ftp.vim.org/vim/runtime/spell'

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

" TODO test (tpope)
" Merge consecutive empty lines and clean up trailing whitespace
" map <Leader>fm :g/^\s*$/,/\S/-j<Bar>%s/\s\+$//<CR>

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

" }}}
"-----------------------------------------------------------

"-----------------------------------------------------------
"                    moving around {{{
"-----------------------------------------------------------

" when pasting code or text, toggle off smartindent
set pastetoggle=<F11>

" Move between visible lines and not between real lines
map <silent> <Up> gk
map <silent> <Down> gj
map <silent> <home> g<home>
map <silent> <end> g<end>

"imap <silent> <Up> <C-o>gk
"imap <silent> <Down> <C-o>gj
imap <silent> <home> <C-o>g<home>
imap <silent> <end> <C-o>g<end>

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

" }}}
"-----------------------------------------------------------

"-----------------------------------------------------------
"                  search and replace {{{
"-----------------------------------------------------------

set incsearch  " show the `best match so far'
set ignorecase " make searches case-insensitive
set smartcase  " unless they contain upper-case characters

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

" }}}
"-----------------------------------------------------------

"-----------------------------------------------------------
"                        comments {{{
"-----------------------------------------------------------

" remove comment leader when joining lines with J:
let &formatoptions.= 'j'

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

" }}}
"-----------------------------------------------------------

"-----------------------------------------------------------
"                      normal mode {{{
"-----------------------------------------------------------

" Spacebar creates spaces in normal mode:
map <Space> i<Space><Esc>l

" Incrementing (ctrl-a, ctrl-x) accepts decimal, hexa and chars (but not octal)
set nrformats="alpha,hex"

" Invoke sudo to write into current open file
command! W w !sudo tee > /dev/null %

" }}}
"-----------------------------------------------------------

"-----------------------------------------------------------
"               completion in insert mode (FIXME) {{{
"-----------------------------------------------------------

" XXX
set dictionary+=/usr/share/dict/words

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

inoremap <expr> <Tab> pumvisible()?"<C-R>=CleverTab()\<CR>":"\<Tab>"

" NeoSnippet: https://github.com/Shougo/neosnippet.vim
" Works better with neocomplcache
" Alternatives for snippets:
"   manual   http://stackoverflow.com/a/13133097
"   snipmate https://github.com/garbas/vim-snipmate
"
" Plugin key-mappings.
imap <C-k>     <Plug>(neosnippet_expand_or_jump)
smap <C-k>     <Plug>(neosnippet_expand_or_jump)
xmap <C-k>     <Plug>(neosnippet_expand_target)
"
" SuperTab-like snippets behavior.
imap <expr><TAB> neosnippet#expandable_or_jumpable() ?
  \ "\<Plug>(neosnippet_expand_or_jump)"
  \: pumvisible() ? "\<C-n>" : "\<TAB>"
smap <expr><TAB> neosnippet#expandable_or_jumpable() ?
  \ "\<Plug>(neosnippet_expand_or_jump)"
  \: "\<TAB>"
"
" For snippet_complete marker.
if has('conceal')
    set conceallevel=2 concealcursor=i
endif
"
" Enable snipMate compatibility feature.
"let g:neosnippet#enable_snipmate_compatibility = 1
" Tell Neosnippet about the other snippets
"let g:neosnippet#snippets_directory='~/.vim/bundle/vim-snippets/snippets'
"
" See repo of snippets: https://github.com/honza/vim-snippets

" }}}
"-----------------------------------------------------------

"-----------------------------------------------------------
"                      ctags, cscope {{{
"-----------------------------------------------------------

if has("cscope")
    set cscopeprg=cscope
    set cscopetagorder=0
    " Make :tag, Ctrl-] etc use cscope+ctags instead of just ctags
    "set cscopetag
    set nocscopeverbose
    " Add any database in current directory
    if filereadable("cscope.out")
        cscope add cscope.out
    endif
    " Add database pointed to by environment
    if $CSCOPE_DB != ""
        cscope add $CSCOPE_DB
    endif
    set cscopeverbose
endif

" Shortcuts: (ctags)
" Ctrl-]   Goes to function declaration (signature)
"            Same as :tag
" g-]      Goes to function definition (implementation)
"            Same as :ts

"map <C-}> :cstag <C-R>=expand("<cword>")<CR><CR>  " => same as <C-]>
map <silent> g[ :cscope find 3 <C-R>=expand("<cword>")<CR><CR>

" http://majutsushi.github.io/tagbar/
nmap <F4> :TagbarToggle<CR>
imap <F4> <Esc>:TagbarToggle<CR>a

" hg clone https://bitbucket.org/abudden/taghighlight
" TagHighlight will highlight ctags from your project and from the standard
" library from your language impl. Problem: scope pollution, it includes JDK
" internal functions even outside their class.

" }}}
"-----------------------------------------------------------

"-----------------------------------------------------------
"                      git integration {{{
"-----------------------------------------------------------

" https://github.com/airblade/vim-gitgutter
map  <F2> ::GitGutterLineHighlightsToggle<CR>
imap <F2> <Esc>::GitGutterLineHighlightsToggle<CR>a
map  <F3> ::GitGutterNextHunk<CR>
imap <F3> <Esc>::GitGutterNextHunk<CR>i
"let g:gitgutter_sign_added = '⇒'
"let g:gitgutter_sign_modified = '⇔'
"let g:gitgutter_sign_removed = '⇐'
"let g:gitgutter_sign_modified_removed = '⇔'
let g:gitgutter_escape_grep = 1              " vanilla grep
"let g:gitgutter_enabled = 0                 " disable by default
"let g:gitgutter_highlight_lines = 1         " line highlight by default
"let g:gitgutter_eager = 0                   " be faster but less up-to-date

" }}}
"-----------------------------------------------------------

"-----------------------------------------------------------
"                   app-specific settings {{{
"-----------------------------------------------------------
"   (Those must not be under .vim/after/)

" https://github.com/embear/vim-localvimrc/
let g:localvimrc_name=[ ".vimrc.local" ]
"let g:localvimrc_ask=0
let g:localvimrc_persistent=2
"let g:localvimrc_whitelist='/home/user/projects/\(foo\|bar\)/.*'

" Assume the shell is Bash (:help sh.vim)
if filereadable("/usr/local/bin/bash")
    " Thanks Apple for the old Bash
    set shell=/usr/local/bin/bash
else
    set shell=/bin/bash
endif
let g:is_bash=1
let g:sh_fold_enabled=3

let g:c_gnu=1

" For clang-complete
"let g:clang_use_library = 1

" Default .tex to LaTeX instead of ConTeXt
let g:tex_flavor = "latex"

" Java : do not highlight 'delete' and such as errors.
let g:java_allow_cpp_keywords = 0
" Num of previous lines used to synchronize highlighting (default 10)
"let java_minlines = 50

" TODO Haskellmode  http://projects.haskell.org/haskellmode-vim
" let haskell_indent_case=4 " (default 5)
" let haskell_indent_if=2   " (default 3)
" let g:haddock_browser="/usr/bin/elinks"
" let g:haddock_browser_callformat="%s file://%s >/dev/null 2>&1 &"
" au BufEnter *.hs compiler ghc

" Haskell conceal  https://github.com/Twinside/vim-haskellConceal
" Uncomment to disable.
"let g:no_haskell_conceal = 1

let g:haddock_browser="/usr/bin/firefox"

" Syntastic
let g:syntastic_auto_loc_list=1

" TagBar
let g:tagbar_autofocus = 1

" :TOhtml
let g:html_number_lines=1  " 0/1, don't/show line numbers
let g:html_use_css=1
let g:use_xhtml=1

" When editing a file, always jump to the last cursor position
augroup from_gentoo
    autocmd BufReadPost *
        \ if line("'\"") > 0 && line ("'\"") <= line("$") |
        \     exe "normal g'\"" |
        \ endif
augroup END

" Modelines : show as comments, no syntax highlight.
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

" TODO Compressed files
"augroup lzma
"    au!
"    au BufReadPre,FileReadPre       *.lzma setlocal bin
"    au BufReadPost,FileReadPost     *.lzma call gzip#read("lzma -d")
"    au BufWritePost,FileWritePost   *.lzma call gzip#write("lzma")
"    au FileAppendPre                *.lzma call gzip#appre("lzma -d")
"    au FileAppendPost               *.lzma call gzip#write("lzma")
"augroup END

" }}}
"-----------------------------------------------------------

"-----------------------------------------------------------
"                       hex editing {{{
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

" }}}
"-----------------------------------------------------------

"-----------------------------------------------------------
"                           misc {{{
"-----------------------------------------------------------

set grepprg=grep\ -rnH\ --exclude='.*.swp'\ --exclude='*~'\ --exclude=tags

" Toggle the NERD_tree plugin
"map <leader>d :execute 'NERDTreeToggle ' . getcwd()<CR>

" }}}
"-----------------------------------------------------------

" pathogen {{{
try
    call pathogen#infect()
    call pathogen#helptags()
catch
endtry
" }}}

" -------------------------
" shortcuts you should know {{{
" -------------------------
"
" Ctrl-A and Ctrl-X   to increment/decrement
" Ctrl-N and Ctrl-P   to auto-complete (ins mode)
"
" K              to reach the man page for the current word
" g Ctrl-G       to count words
" \i<CR>         to split a line at the cursor's position (similar to S)
"
" gd,  gD        go to var definition (local/global)
" *,  g*         search (exact word/containing word)
"
" :Ex            to explore the opened file's directory
" :n . and :e .  to explore the shell's PWD
"
" :retab         to convert tabs to spaces
"
" In Insert mode: Ctrl-R=<some simple math like 2+2><CR>
"
" Copy-paste integration:
"   visual mode (V or Ctrl-V), highlight text,  ?+y
"   now the text is in the standard (X? OS?) clipboard.
"
"   Pasting from OS clipboard into Vim:  ?+gP
"
" }}}
" -------------------------
