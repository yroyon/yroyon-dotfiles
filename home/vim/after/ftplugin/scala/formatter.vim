if executable('scalariform')
    setlocal formatprg=scalariform\ -f\ -q\ -spacesAroundMultiImports\ --stdin\ --stdout
endif
