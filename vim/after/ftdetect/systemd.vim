" systemd unit files
" Can use filetype: gitconfig povini
au BufRead,BufNewFile *.{automount,mount,netdev,network,path,service,slice,socket,swap,target,timer} setfiletype gitconfig
