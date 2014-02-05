" Re-indent a Json file using Python's json module
" Doesn't seem to work for Json objects embedded in e.g. a bash script
if executable('python')
    command! -range -nargs=0 -bar JsonIndent <line1>,<line2>!python -m json.tool
    " equalprg is broken -- only works for a full JSON document
    "setlocal equalprg=python\ -m\ json.tool
endif
