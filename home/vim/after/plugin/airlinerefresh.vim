if !exists('g:loaded_airline')
    finish
endif

augroup airlinerefresh
    autocmd!
    autocmd VimEnter * :AirlineRefresh
augroup END
