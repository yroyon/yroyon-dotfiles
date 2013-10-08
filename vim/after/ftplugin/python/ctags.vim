""      Run once in a /bin/sh:
"" ctags -R -f ~/.vim/tags/python.ctags /usr/lib/python
""      But this doesn't work as advertised:
""      it only reads Makefile tags, even if --language-force. So:
"" find /usr/lib/python2.6 -name \*.py -print | xargs /home/yroyon/scripts/ptags.py
""      (using a ptags.py found on the net, supposedly in Tools/scripts/ptags.py
""      in Python distributions - but not in Gentoo)

setlocal tags+=$HOME/.vim/tags/python.ctags

