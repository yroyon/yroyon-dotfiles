if has('gui_running')
    set bg=dark
    color wombat
    "remove scrollbars and toolbar
    set guioptions-=T
    set guioptions-=l
    set guioptions-=L
    set guioptions-=r
    set guioptions-=R
    set guifont=Terminus\ 8
    "set guifont=Consolas\ 8.5
    set gcr=n-v-c:block-blinkwait0-blinkon0-blinkoff0
    highlight Todo guibg=bg guifg=#FF4400
    highlight String gui=None
    if has('mac')
        set transparency=3
        hi CursorLine guibg=#2e2e37 gui=NONE
    endif
    set t_Co=256
else
    set t_Co=256
    colorscheme wombat256
endif
if (&term == 'screen-bce')  || (&term == 'xterm-color') || (&term == 'builtin_gui') || (&term == 'xterm') || (&term == 'screen') || (&term == 'rxvt-unicode-256color')
    if has ('mac')
        set t_Co=16
        set bg=light
        colorscheme default
    endif

    highlight String gui=None
    highlight CurrenLine ctermbg=238
    highlight Comment       ctermfg=darkgray
    highlight Comments      ctermfg=darkgray
    highlight DiffAdd       ctermbg=darkgreen   ctermfg=white
    highlight DiffChange    ctermbg=darkblue    ctermfg=white
    highlight DiffDelete    ctermbg=darkred     ctermfg=white
    highlight DiffText      ctermbg=darkred     ctermfg=white
    highlight Folded        ctermfg=black
    highlight LineNr        ctermfg=darkgray
    highlight MatchParen    None
    highlight MatchParen    ctermfg=cyan        guifg=cyan
    highlight Pmenu         ctermbg=darkgray
    highlight PmenuSel      ctermbg=darkgray    ctermfg=white   cterm=underline
    highlight Search        ctermfg=black       ctermbg=yellow
    highlight ShowMarksHLl  ctermfg=darkyellow  ctermbg=black
    highlight ShowMarksHLm  ctermfg=darkyellow  ctermbg=black
    highlight ShowMarksHLo  ctermfg=darkyellow  ctermbg=black
    highlight ShowMarksHLu  ctermfg=darkyellow  ctermbg=black
    highlight SignColumn    ctermfg=white       ctermbg=black
    highlight SpellBad      ctermfg=white       ctermbg=red
    highlight SpellLocal    ctermfg=yellow      ctermbg=none
    highlight Visual        ctermfg=white ctermbg=238
    highlight mailQuoted1 NONE
    highlight mailQuoted2 NONE
    highlight mailQuoted3 NONE
    highlight mailQuoted4 NONE
    highlight mailQuoted1 ctermfg=yellow guifg=#edf28a
    highlight link mailQuoted2 String
    highlight link mailQuoted3 Keyword
    highlight link mailQuoted4 Constant
    highlight mailSignature NONE
    highlight link mailSignature Comment
    highlight preproc       ctermfg=red cterm=bold
    highlight FoldColumn    ctermfg=yellow      ctermbg=black
    highlight Folded        ctermfg=yellow      ctermbg=darkgray
    highlight StatusLine    ctermfg=white ctermbg=darkgrey cterm=none term=none
    highlight StatusLineNC  ctermfg=white ctermbg=darkgray cterm=none term=none
    highlight VertSplit     ctermbg=darkgray    cterm=none term=none
    highlight NonText       None
    highlight NonText       ctermfg=9 guifg=#404040 term=bold

    " TagList
    highlight TagListFilename NONE
    highlight TagListComment NONE
    highlight TagListTagName NONE
    highlight TagListTitle NONE
    highlight link TagListFileName Comment
    highlight link TagListComment Comment
    highlight link TagListTagName Character
    highlight link TagListTitle Statement

    " NERDTree
    highlight treeCWD NONE
    highlight treeUp NONE
    highlight link treeCWD TODO
    highlight link treeUp Comment

    " MiniBufExplorer
    highlight MBENormal         ctermfg=darkgray
    highlight MBEChanged        ctermfg=red
    highlight MBEVisibleNormal  ctermfg=white
    highlight MBEVisibleChanged ctermfg=darkyellow

    " PyFlakes
    highlight PyFlakes guifg=#FF0000

    " Other stuff
    "highlight LongLines guibg=#3B0300 ctermbg=darkred
    "au BufWinEnter * let w:m2=matchadd('LongLines', '\%>80v.\+', -1)
    highlight ColorColumn guibg=#202020 ctermbg=238
    highlight Todo ctermfg=202 ctermbg=none
    highlight Directory term=underline cterm=bold ctermfg=11 guifg=#cae682

endif
