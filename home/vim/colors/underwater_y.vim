" Maintainer: Dmitry Kichenko (dmitrykichenko@gmail.com)
" Last Change:	February 18, 2010
" yroyon 2010-02-20:
"     added cterm colors (based on http://gist.github.com/307848)
"     changed Normal ctermbg to almost-black (black is 232)

set background=dark

hi clear

if exists("syntax_on")
  syntax reset
endif

let colors_name = "underwater"

" Vim >= 7.0 specific colors
if version >= 700
  " highlights current line
  hi CursorLine   guibg=#18374F ctermbg=23
  " cursor's colour
  hi CursorColumn guibg=#ffffff ctermbg=15
  hi MatchParen   guifg=#ffffff guibg=#439ea9 gui=bold ctermfg=15 ctermbg=73
  hi Pmenu 		    guifg=#dfeff6 guibg=#1E415E ctermfg=195 ctermbg=23
  hi PmenuSel 	  guifg=#dfeff6 guibg=#2D7889 ctermfg=195 ctermbg=30

  " Search
  hi IncSearch  gui=BOLD guifg=#E2DAEF guibg=#AF81F4 ctermfg=7 ctermbg=141
  hi Search     gui=NONE guifg=#E2DAEF guibg=#AF81F4 ctermfg=7 ctermbg=141
endif

" General colors
hi Cursor 		  guifg=NONE    guibg=#55A096 gui=none   ctermbg=73
hi Normal 		  guifg=#dfeff6 guibg=#102235 gui=none   ctermfg=195 ctermbg=233
 " e.g. tildes at the end of file
hi NonText 		  guifg=#96defa guibg=#122538 gui=none   ctermfg=117 ctermbg=235
hi LineNr 		  guifg=#2F577C guibg=#0C1926 gui=none   ctermfg=24  ctermbg=234
hi StatusLine 	guifg=#96defa guibg=#0C1926 gui=italic ctermfg=117 ctermbg=234
hi StatusLineNC guifg=#68CEE8 guibg=#0C1926 gui=none   ctermfg=80  ctermbg=234
hi VertSplit 	  guifg=#1A3951 guibg=#1A3951 gui=none   ctermfg=237 ctermbg=237
hi Folded 		  guifg=#68CEE8 guibg=#1A3951 gui=none   ctermfg=80  ctermbg=237
hi FoldColumn   guifg=#1E415E guibg=#1A3951 gui=none   ctermfg=23  ctermbg=237
hi Title		    guifg=#dfeff6 guibg=NONE	  gui=bold   ctermfg=195
 " Selected text color
hi Visual		    guifg=#dfeff6 guibg=#24557A gui=none   ctermfg=195 ctermbg=24
hi SpecialKey	  guifg=#3e71a1 guibg=#102235 gui=none   ctermfg=61  ctermbg=235

"
" Syntax highlighting
"
hi Comment 		guifg=#3e71a1 gui=italic    ctermfg=61
hi Todo 		  guifg=#ADED80 guibg=#579929 gui=bold
hi Constant 	guifg=#96defa gui=none      ctermfg=156 ctermbg=64
hi String 		guifg=#89e14b gui=italic    ctermfg=113
 " names of variables in PHP
hi Identifier guifg=#8ac6f2 gui=none ctermfg=117
 " Function names as in python. currently purpleish
hi Function 	guifg=#AF81F4 gui=none ctermfg=141
 " declarations of type
hi Type 		  guifg=#41B2EA gui=none ctermfg=74
 " statement, such as 'hi' right here
hi Statement 	guifg=#68CEE8 gui=none ctermfg=80
hi Keyword		guifg=#8ac6f2 gui=none ctermfg=117
 "  specified preprocessed words (like bold, italic etc. above)
hi PreProc 		guifg=#EF6145 gui=none ctermfg=203
hi Number		  guifg=#96defa gui=none ctermfg=117
hi Special		guifg=#DFEFF6 gui=none ctermfg=195


