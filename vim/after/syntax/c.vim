
"" Turned locally defined functions into highlighted matches
syn match cCustomParen "?=(" contains=cParen,cCppParen
syn match cCustomFunc "\w\+\s*(\@=" contains=cCustomParen
syn match cCustomScope "::"
syn match cCustomClass "\w\+\s*::" contains=cCustomScope
hi def link cCustomFunc Function
hi def link cCustomClass Function


"" Add custom highlight to my own todo items
"syn match   cTodo /\<TODO:/
"hi def link yTodo Todo
"
"syn match   ydox contained  "\<@\(bug\|todo\|note\|warning\)"
"syn keyword ydox contained  @bug @todo @note @warning
"syn keyword ydox @todo
"hi def ydox ctermfg=darkblue cterm=underline
"hi def link ydox PreProc
"
" XXX It doesn't work. XXX
