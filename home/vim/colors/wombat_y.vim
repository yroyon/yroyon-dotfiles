" Wombat by Lars H. Nielsen, cterm additions by Paul deGrandis
" Changes and additional stuff by Yvan Royon
" See :help highlight-groups for the list of available hl groups

set background=dark

hi clear

if exists('syntax_on')
  syntax reset
endif

let g:colors_name = 'wombat'

" General colors
hi Cursor       ctermfg=none ctermbg=241  cterm=none
hi Folded       ctermfg=248  ctermbg=237  cterm=none
hi LineNr       ctermfg=101  ctermbg=234  cterm=none
hi NonText      ctermfg=244  ctermbg=234  cterm=none
hi Normal       ctermfg=230  ctermbg=232  cterm=none
hi SpecialKey   ctermfg=244  ctermbg=236  cterm=none
hi StatusLine   ctermfg=230  ctermbg=238  cterm=none
hi StatusLineNC ctermfg=101  ctermbg=238  cterm=none
hi Title        ctermfg=230  ctermbg=none cterm=bold
hi VertSplit    ctermfg=238  ctermbg=238  cterm=none
hi Visual       ctermfg=230  ctermbg=238  cterm=none

hi CursorColumn              ctermbg=236
hi CursorLine                ctermbg=236
hi MatchParen   ctermfg=230  ctermbg=101  cterm=bold
hi Pmenu        ctermfg=230  ctermbg=238
hi PmenuSel     ctermfg=0    ctermbg=186

" Syntax highlighting
hi Comment      ctermfg=246               cterm=none
hi Todo         ctermfg=245               cterm=none
hi Constant     ctermfg=185               cterm=none
hi String       ctermfg=154               cterm=none
hi Identifier   ctermfg=186               cterm=none
hi Function     ctermfg=187               cterm=bold
hi Type         ctermfg=186               cterm=none
hi Statement    ctermfg=lightblue         cterm=bold
hi Keyword      ctermfg=105               cterm=none
hi PreProc      ctermfg=173               cterm=none
hi Number       ctermfg=185               cterm=none
hi Special      ctermfg=7                 cterm=none

hi Conceal      ctermfg=lightblue         ctermbg=none

"Directory
"DiffText
"ErrorMsg
"FoldColumn
"IncSearch
"CursorLineNr
"ModeMsg
"MoreMsg
"PmenuSbar
"PmenuThumb
"Question
"Search
"SpellBad
"SpellCap
"SpellLocal
"SpellRare
"TabLine
"TabLineFill
"TabLineSel
"WarningMsg
"WildMenu


" Diff
hi DiffAdd     ctermbg=22 guibg=DarkBlue
hi DiffChange  ctermbg=17 guibg=DarkMagenta
hi DiffDelete  ctermbg=52 guibg=DarkCyan

" airblade/vim-gitgutter
hi SignColumn                        ctermbg=235
hi GitGutterAdd           ctermfg=2  ctermbg=235
hi GitGutterChange        ctermfg=3  ctermbg=235
hi GitGutterDelete        ctermfg=1  ctermbg=235
hi GitGutterChangeDelete  ctermfg=3  ctermbg=235
"hi link GitGutterAdd           DiffAdd
"hi link GitGutterChange        DiffChange
"hi link GitGutterDelete        DiffDelete
"hi link GitGutterChangeDelete  DiffChange

