## This file should generate no output or it will break the scp | rcp commands.

source /etc/profile
## If not running interactively, don't do anything
[ -z "$PS1" ] && return
[ -f "${HOME}"/.dir_colors ] && eval $(dircolors -b "${HOME}"/.dir_colors)

## ls family
alias      d="/bin/ls --color"
alias      l="/bin/ls --color --group-directories-first -FX"
alias     ll="/bin/ls --color --group-directories-first -FXAlh"
alias llsize="/bin/ls --color --group-directories-first -FXAlh --sort=size"
alias    lsd="/bin/ls --color -d */"
alias  lsdir="tree -d -L 1 -i -A"
alias lsdirs="tree -d -A"

## grep family
alias grepc="grep -r --include=*.{java,c,C,cc,CC,cpp,h,H,sh,scala,hs,rb,py,pl,properties}"
alias grepd="grep -r --include=*.{txt,html,htm,tex,bib,asciidoc,md,markdown,rst}"
alias grepb="grep -r --include=*.{mk,am,ac,in,m4,sh,xml,properties} --include=*akefile --include=*configure* --include=GNUmake*"
alias grepwhite="grep '[[:space:]]\+$' -r ."
alias g=grepc

dirsize() {
    find ${1-.} -maxdepth 1 -type d -exec du -hs '{}' \;
}

lsize() {
    du -b --max-depth 1 ${1} | sort -nr | perl -pe \
        's{([0-9]+)}{sprintf "%.1f%s", $1>=2**30? ($1/2**30, "G"): $1>=2**20? ($1/2**20, "M"): $1>=2**10? ($1/2**10, "K"): ($1, "")}e'
}

histostats() {
    history | awk '{a[$2]++ } END{for(i in a){print a[i] " " i}}' | sort -rn | head
}

## default options to common commands
alias diff="colordiff -NrbB"
# Patching: git diff > patchfile  ;  patch -p1 < patchfile
alias grep="/bin/grep --color"
alias rm="rm -i"
alias tree="/usr/bin/tree --dirsfirst"

## locale issues
alias calibre="LC_ALL=en_US calibre"
alias git="LC_ALL=fr_FR@euro git"
alias glade="LC_ALL=en_US glade-3"
alias wicd-curses="LC_ALL=C wicd-curses"

## colours
alias cvs="grc cvs"
alias netstat="grc netstat"
alias ping="grc ping"
alias svn="grc svn"
alias traceroute="grc traceroute"

## new commands
alias dvdplay="mplayer -nocache dvdnav://"
alias emptytrash="rm -rf ~/.local/share/Trash/*"
alias loffice="libreoffice"
alias manga="thunar &>/dev/null &"
alias path='echo -e ${PATH//:/\\n}'
alias perf="/usr/src/linux/tools/perf/perf"
alias quickweb='python2 -m SimpleHTTPServer'
alias quickweb3='python3 -m http.server'
## for some TERM issues
alias rxvt="urxvt"
alias rxvt-unicode="urxvt"
alias xpdf="epdfview"
#alias xpdf="zathura"


#alias hd='od -Ax -tx1z -v'
#alias realpath='readlink -f'

shopt -s checkwinsize
shopt -s dotglob
shopt -s extglob
shopt -s histappend
shopt -s no_empty_cmd_completion
shopt -s globstar
## ** pattern

complete -cf sudo

export CVS_RSH=/usr/bin/ssh
export EDITOR=/usr/bin/vim
export FIGNORE=".svn:CVS"
export GREP_COLOR=32
export GREP_OPTIONS="--color=auto --exclude="tags" --exclude-dir=CVS --exclude-dir=.svn --exclude-dir=.git --exclude-dir=.hg --exclude-dir=.bzr --exclude-dir=_darcs --binary-files=without-match"
export HISTIGNORE="&:l:ll:ls:pwd:[bf]g:exit:clear:[ ]*"
export HISTSIZE=4096
export HISTFILESIZE=2097152
export LESS="$LESS --ignore-case"
export PATH+=":${HOME}/scripts"
[ -d "${HOME}"/scripts/games ] && export PATH+=":${HOME}/scripts/games"

export JAVA_HOME=$(java-config -o)
export JAVAC="${JAVA_HOME}"/bin/javac

## VMware segfaults @work without this:
export VMWARE_USE_SHIPPED_GTK=force

## For JOGL (it seems the default is missing .so)
export EGL_DRIVER=/usr/lib/egl/egl_glx.so

## ooffice is veeery slow to start if the print server is unreachable
##   (ServerName in /etc/cups/client.conf).
## => set to any non-empty value:
export SAL_DISABLE_SYNCHRONOUS_PRINTER_DETECTION="a"

## PROMPT_COMMAND : window title for X terminals
##            PS1 : shell prompt
case $TERM in
	xterm*|rxvt*)
		PROMPT_COMMAND='echo -ne "\033]0;${USER}@${HOSTNAME%%.*}:${PWD/$HOME/~}\007"'
		PS1='\[\033[01;34m\]`mytty=$(tty) ; echo ${mytty:5}` [\j] \[\033[01;32m\]\u@\h \[\033[01;34m\]\W \[\033[01;34m\][`ls -1 | wc -l`] \$ \[\033[00m\]'
		;;
	screen*)
		PROMPT_COMMAND='echo -ne "\033_${USER}@${HOSTNAME%%.*}:${PWD/$HOME/~}\033\\"'
		PS1='\[\033[01;36m\]screen`mytty=$(tty) ; echo ${mytty:8}` \[\033[01;32m\]\u@\h \[\033[01;36m\]\W \[\033[01;36m\][`ls -1 | wc -l`] \$ \[\033[00m\]'
		;;
esac
export PS1

[ -f /etc/profile.d/bash-completion ]     && source /etc/profile.d/bash-completion
[ -f /etc/profile.d/bash-completion.sh ]  && source /etc/profile.d/bash-completion.sh
[ -f /usr/share/compleat/compleat_setup ] && source /usr/share/compleat/compleat_setup
[ -f /usr/bin/ssh-askpass-fullscreen ]    && export SUDO_ASKPASS=/usr/bin/ssh-askpass-fullscreen

