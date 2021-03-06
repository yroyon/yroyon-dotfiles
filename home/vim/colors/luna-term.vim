" Name: Luna vim colorscheme
" Author: Pratheek
" URL: http://github.com/notpratheek/vim-luna
" License: MIT (see LICENSE.rst in the root of project)
" Version: 0.0.7-modified

" Usage and Requirements "{{{
" ---------------------------------------------------------------------
" REQUIREMENTS:
" ---------------------------------------------------------------------
" Currently,
"
" This colourscheme is intended for use on:
" - Console Vim >= 7.3 for Linux, Mac and Windows.
"   (Use luna.vim, if you use gvim rather than console vim)
" }}}

" Colorscheme initialization "{{{
" ---------------------------------------------------------------------
set background=dark
highlight clear
if exists("syntax_on")
    syntax reset
endif
let g:colors_name = "luna-term"
" }}}

" Console vim Highlighting: (see :help highlight-groups)"{{{
" ---------------------------------------------------------------------
" First, the Normal
hi Normal        ctermfg=254 ctermbg=232 cterm=NONE
" ---------------------------------------------------------------------
" The Languages stuff
"hi Title         ctermfg=195 ctermbg=NONE cterm=NONE
hi Title         ctermfg=166 ctermbg=NONE cterm=NONE
" ---------------------------------------------------------------------
hi Comment       ctermfg=240  ctermbg=NONE cterm=NONE
" ---------------------------------------------------------------------
hi Constant      ctermfg=227  ctermbg=NONE cterm=NONE
hi String        ctermfg=74   ctermbg=NONE cterm=NONE
hi Character     ctermfg=211  ctermbg=NONE cterm=NONE
hi Number        ctermfg=227  ctermbg=NONE cterm=NONE
hi Boolean       ctermfg=227  ctermbg=NONE cterm=NONE
hi Float         ctermfg=227  ctermbg=NONE cterm=NONE
" ---------------------------------------------------------------------
hi Identifier    ctermfg=37   ctermbg=NONE cterm=NONE
hi Function      ctermfg=37   ctermbg=NONE cterm=NONE
" ---------------------------------------------------------------------
hi Statement     ctermfg=204  ctermbg=NONE cterm=NONE
hi Conditional   ctermfg=184  ctermbg=NONE cterm=NONE
hi Operator      ctermfg=202  ctermbg=NONE cterm=NONE
hi Exception     ctermfg=184  ctermbg=NONE cterm=NONE
" ---------------------------------------------------------------------
hi PreProc       ctermfg=149  ctermbg=NONE cterm=NONE
" ---------------------------------------------------------------------
hi Type          ctermfg=203  ctermbg=NONE cterm=NONE
hi StorageClass  ctermfg=173  ctermbg=NONE cterm=NONE
" ---------------------------------------------------------------------
hi Special       ctermfg=211  ctermbg=NONE cterm=NONE
" ---------------------------------------------------------------------
hi Underlined    ctermfg=111  ctermbg=NONE cterm=NONE
" ---------------------------------------------------------------------
hi Error         ctermfg=88   ctermbg=214 cterm=NONE
" ---------------------------------------------------------------------
hi TODO          ctermfg=198  ctermbg=228 cterm=NONE

" ---------------------------------------------------------------------
" Extended Highlighting

hi NonText      ctermfg=244  ctermbg=NONE cterm=NONE
hi Visual       ctermfg=235  ctermbg=227  cterm=NONE
hi ErrorMsg     ctermfg=88   ctermbg=214  cterm=NONE
hi IncSearch    ctermfg=235  ctermbg=208  cterm=NONE
hi Search       ctermfg=235  ctermbg=208  cterm=NONE
hi MoreMsg      ctermfg=241  ctermbg=NONE cterm=NONE
hi ModeMsg      ctermfg=241  ctermbg=NONE cterm=NONE
hi LineNr       ctermfg=244  ctermbg=234  cterm=NONE
hi VertSplit    ctermfg=0    ctermbg=238  cterm=NONE
hi VisualNOS    ctermfg=235  ctermbg=227  cterm=NONE
hi Folded       ctermfg=23   ctermbg=235  cterm=NONE
hi DiffAdd      ctermfg=231  ctermbg=22   cterm=NONE
hi DiffChange   ctermfg=231  ctermbg=30   cterm=NONE
hi DiffDelete   ctermfg=196  ctermbg=88   cterm=NONE
hi DiffText     ctermfg=000  ctermbg=214  cterm=NONE
hi SpellBad     ctermfg=160  ctermbg=228  cterm=NONE
hi SpellCap     ctermfg=130  ctermbg=228  cterm=NONE
hi SpellRare    ctermfg=196  ctermbg=228  cterm=NONE
hi SpellLocal   ctermfg=28   ctermbg=228  cterm=NONE
hi StatusLine   ctermfg=231  ctermbg=23   cterm=NONE
hi StatusLineNC ctermfg=231  ctermbg=238  cterm=NONE
hi Pmenu        ctermfg=14   ctermbg=23   cterm=NONE
hi PmenuSel     ctermfg=23   ctermbg=15   cterm=NONE
hi PmenuSbar    ctermfg=235  ctermbg=235  cterm=NONE
hi PmenuThumb   ctermfg=235  ctermbg=235  cterm=NONE
hi MatchParen   ctermfg=16   ctermbg=203  cterm=NONE
hi CursorLine   ctermfg=NONE ctermbg=236  cterm=NONE
hi CursorLineNr ctermfg=117  ctermbg=NONE cterm=NONE
hi CursorColumn ctermfg=NONE ctermbg=236  cterm=NONE
hi ColorColumn  ctermfg=NONE ctermbg=237  cterm=NONE
hi WildMenu     ctermfg=23   ctermbg=231  cterm=NONE
hi SignColumn   ctermfg=NONE ctermbg=234  cterm=NONE
"
" }}}

" yroyon: {{{
" Diff
" hi DiffAdd     ctermbg=22 guibg=DarkBlue
" hi DiffChange  ctermbg=17 guibg=DarkMagenta
" hi DiffDelete  ctermbg=52 guibg=DarkCyan
"
" airblade/vim-gitgutter
" hi SignColumn                        ctermbg=235
hi GitGutterAdd           ctermfg=2  ctermbg=234
hi GitGutterChange        ctermfg=3  ctermbg=234
hi GitGutterDelete        ctermfg=1  ctermbg=234
hi GitGutterChangeDelete  ctermfg=3  ctermbg=234

" Conceal
hi Conceal      ctermfg=lightblue         ctermbg=none
" }}}

" Language Specifics: {{{
" ---------------------------------------------------------------------
" These are language specifics. These are set explicitly to override the group
" highlighting provided by vim (Simply to make the language that you're working
" on more awesome, and fun to work with !)
" ---------------------------------------------------------------------
" Python Specifics
hi pythonDot                ctermfg=161 ctermbg=NONE cterm=NONE
hi pythonParameters         ctermfg=149 ctermbg=NONE cterm=NONE
hi pythonClassParameters    ctermfg=149 ctermbg=NONE cterm=NONE
hi pythonClass              ctermfg=37  ctermbg=NONE cterm=NONE
"
" ---------------------------------------------------------------------
"  Ruby Specifics
hi rubyInterpolation      ctermfg=203 ctermbg=NONE cterm=NONE
hi rubyMethodBlock        ctermfg=216 ctermbg=NONE cterm=NONE
hi rubyCurlyBlock         ctermfg=204 ctermbg=NONE cterm=NONE
hi rubyDoBlock            ctermfg=204 ctermbg=NONE cterm=NONE
hi rubyBlockExpression    ctermfg=204 ctermbg=NONE cterm=NONE
hi rubyArrayDelimiter     ctermfg=37  ctermbg=NONE cterm=NONE
"
" ---------------------------------------------------------------------
"
" }}}

" Extras: {{{
" ---------------------------------------------------------------------
" These are extra parts for highlighting certain external plugins
" ---------------------------------------------------------------------
"
" Startify (https://github.com/mhinz/vim-startify)
"
hi StartifyBracket  ctermfg=98  guibg=NONE gui=NONE
hi StartifyNumber   ctermfg=179 guibg=NONE gui=NONE
hi StartifySpecial  ctermfg=23  guibg=NONE gui=NONE
hi StartifyPath     ctermfg=239 guibg=NONE gui=NONE
hi StartifySlash    ctermfg=238 guibg=NONE gui=NONE
hi StartifyFile     ctermfg=204 guibg=NONE gui=NONE
hi StartifyHeader   ctermfg=216 guibg=NONE gui=NONE
hi StartifyFooter   ctermfg=167 guibg=NONE gui=NONE
"
" ---------------------------------------------------------------------
"
" Signify (https://github.com/mhinz/vim-signify)
"
hi SignifySignAdd    ctermfg=40  ctermbg=234 cterm=NONE
hi SignifySignChange ctermfg=214 ctermbg=234 cterm=NONE
hi SignifySignDelete ctermfg=196 ctermbg=234 cterm=NONE
"
" ---------------------------------------------------------------------
" }}}

" vim:foldmethod=marker:foldlevel=0:textwidth=79
