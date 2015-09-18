" https://github.com/kien/rainbow_parentheses.vim
" https://github.com/jbnicolai/rainbow_parentheses.vim

if !exists('RainbowParenthesesActivate')
    finish
endif

au VimEnter * RainbowParenthesesActivate

au Syntax * RainbowParenthesesLoadChevrons
au Syntax * RainbowParenthesesLoadRound
au Syntax * RainbowParenthesesLoadSquare
au Syntax * RainbowParenthesesLoadBraces


