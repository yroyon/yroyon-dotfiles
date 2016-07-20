" Some config files in /etc expect 8-space tabs for visual alignment
au BufRead /etc/{protocols,rpc,services} setlocal ts=8 sw=8 noet sts=8
au BufRead /etc/{locale.alias,manpath.config,mime.types,request-key.conf} setlocal ts=8 sw=8 noet sts=8
