setlocal spell spelllang=en
setlocal textwidth=74
setlocal spellfile=~/.vim/spell/myspellfile.iso-8859-15.add

highlight clear SpellBad
highlight SpellBad term=standout ctermfg=1 term=underline cterm=underline
highlight clear SpellCap
highlight SpellCap term=underline cterm=underline
highlight clear SpellRare
highlight SpellRare term=underline cterm=underline
highlight clear SpellLocal
highlight SpellLocal term=underline cterm=underline

highlight Comment ctermfg=cyan cterm=none

syn region texMatcher matchgroup=Delimiter start="\\<" skip="\\\\\|\\[{}]" end=">" contains=@texMatchGroup

