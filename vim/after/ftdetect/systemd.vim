" systemd unit files
" Can use filetype: gitconfig povini
au BufRead,BufNewFile *.{automount,mount,netdev,network,path,service,slice,socket,swap,target,timer} setfiletype systemd

" .template files for maikai-prov and iwakalua-prov are systemd templates;
" use this instead of vim's default (ft=json)
au BufRead,BufNewFile *.service.template setfiletype systemd
