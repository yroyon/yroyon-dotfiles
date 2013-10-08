" Maintainer:   Lars H. Nielsen (dengmao@gmail.com)
" Cterm addition: Paul deGrandis
" Last Change:  January 22 2007

set background=dark

hi clear

if exists("syntax_on")
  syntax reset
endif

let colors_name = "wombat"

" General colors
hi Cursor       guifg=none    guibg=#656565 gui=none   ctermfg=none ctermbg=241  cterm=none
hi Folded       guifg=#a0a8b0 guibg=#384048 gui=none   ctermfg=248  ctermbg=237  cterm=none
hi LineNr       guifg=#857b6f guibg=#000000 gui=none   ctermfg=101  ctermbg=234  cterm=none
hi NonText      guifg=#808080 guibg=#303030 gui=none   ctermfg=244  ctermbg=234  cterm=none
hi Normal       guifg=#f6f3e8 guibg=#242424 gui=none   ctermfg=230  ctermbg=232  cterm=none
hi SpecialKey   guifg=#808080 guibg=#343434 gui=none   ctermfg=244  ctermbg=236  cterm=none
hi StatusLine   guifg=#f6f3e8 guibg=#444444 gui=italic ctermfg=230  ctermbg=238  cterm=none
hi StatusLineNC guifg=#857b6f guibg=#444444 gui=none   ctermfg=101  ctermbg=238  cterm=none
hi Title        guifg=#f6f3e8 guibg=none    gui=bold   ctermfg=230  ctermbg=none cterm=bold
hi VertSplit    guifg=#444444 guibg=#444444 gui=none   ctermfg=238  ctermbg=238  cterm=none
hi Visual       guifg=#f6f3e8 guibg=#444444 gui=none   ctermfg=230  ctermbg=238  cterm=none

hi CursorColumn               guibg=#2d2d2d                         ctermbg=236
hi CursorLine                 guibg=#2d2d2d                         ctermbg=236
hi MatchParen   guifg=#f6f3e8 guibg=#857b6f gui=bold   ctermfg=230  ctermbg=101  cterm=bold
hi Pmenu        guifg=#f6f3e8 guibg=#444444            ctermfg=230  ctermbg=238
hi PmenuSel     guifg=#000000 guibg=#cae682            ctermfg=0    ctermbg=186

" Syntax highlighting
hi Comment      guifg=#99968b               gui=italic ctermfg=246               cterm=none
hi Todo         guifg=#8f8f8f               gui=italic ctermfg=245               cterm=none
hi Constant     guifg=#e5786d               gui=none   ctermfg=185               cterm=none
hi String       guifg=#95e454               gui=italic ctermfg=154               cterm=none
hi Identifier   guifg=#cae682               gui=none   ctermfg=186               cterm=none
hi Function     guifg=#cae682               gui=none   ctermfg=187               cterm=bold
hi Type         guifg=#cae682               gui=none   ctermfg=186               cterm=none
hi Statement    guifg=#8ac6f2               gui=none   ctermfg=lightblue         cterm=bold
hi Keyword      guifg=#8ac6f2               gui=none   ctermfg=105               cterm=none
hi PreProc      guifg=#e5786d               gui=none   ctermfg=173               cterm=none
hi Number       guifg=#e5786d               gui=none   ctermfg=185               cterm=none
hi Special      guifg=#e7f6da               gui=none   ctermfg=7                 cterm=none

hi Conceal      guifg=lightblue guibg=none  ctermfg=lightblue ctermbg=none

" :help highlight-groups
"Directory
"DiffText
"ErrorMsg
"VertSplit
"FoldColumn
"SignColumn
"IncSearch
"LineNr
"CursorLineNr
"MatchParen
"ModeMsg
"MoreMsg
"NonText
"PmenuSbar
"PmenuThumb
"Question
"Search
"SpecialKey
"SpellBad
"SpellCap
"SpellLocal
"SpellRare
"StatusLine
"StatusLineNC
"TabLine
"TabLineFill
"TabLineSel
"Title
"Visual
"WarningMsg
"WildMenu


" Diff
hi DiffAdd     ctermbg=22 guibg=DarkBlue
hi DiffChange  ctermbg=17 guibg=DarkMagenta
hi DiffDelete  ctermbg=52 guibg=DarkCyan

" airblade/vim-gitgutter
hi SignColumn                           guibg=#242424           ctermbg=235
hi GitGutterAdd           guifg=#009900 guibg=#242424 ctermfg=2 ctermbg=235
hi GitGutterChange        guifg=#bbbb00 guibg=#242424 ctermfg=3 ctermbg=235
hi GitGutterDelete        guifg=#ff2222 guibg=#242424 ctermfg=1 ctermbg=235
hi GitGutterChangeDelete  guifg=#bbbb00 guibg=#242424 ctermfg=3 ctermbg=235
"hi link GitGutterAdd           DiffAdd
"hi link GitGutterChange        DiffChange
"hi link GitGutterDelete        DiffDelete
"hi link GitGutterChangeDelete  DiffChange

