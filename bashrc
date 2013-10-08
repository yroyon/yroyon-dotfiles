## This file should generate no output or it will break the scp | rcp commands.

. /etc/profile
## If not running interactively, don't do anything
[[ -z "$PS1" ]] && return
[[ -f "${HOME}"/.dir_colors ]] && eval $(dircolors -b "${HOME}"/.dir_colors)

## ls family new commands
alias      d="/bin/ls --color --group-directories-first"
alias      l="/bin/ls --color --group-directories-first -FX"
alias     ll="/bin/ls --color --group-directories-first -FXAlh"
alias llsize="/bin/ls --color --group-directories-first -FXAlh --sort=size"
alias    lsd="/bin/ls --color -d */"
alias  lsdir="/usr/bin/tree -d -L 1 -i"
alias lsdirs="/usr/bin/tree -d"

## grep family new commands
alias grepc="grep -R --exclude=* --include=*.{c,C,cc,CC,cpp,h,H,hs,java,pl,properties,py,rb,s,S,scala,sh}"
alias grepd="grep -R --exclude=* --include=*.{asciidoc,bib,howto,info,markdown,md,txt,htm,html,rst,tex,todo,txt,wip}"
alias grepb="grep -R --exclude=* --include=*.{ac,am,in,m4,mk,properties,sh,xml} --include=*akefile --include=*configure* --include=GNUmake*"
alias grepwhite="grep '[[:space:]]\+$' -R"
alias g=grepc

## git family new commands
alias gdiff="git diff | vim - -R -c 'set filetype=git' -c 'set foldmethod=syntax'"
alias glog="git log -p $@ | vim - -R -c 'set foldmethod=syntax'"

## propagate (sub-)command completion when using sudo
alias sudo='sudo '

## default options to common commands
alias diff="colordiff -NrbB"
# Patching: git diff > patchfile  ;  patch -p1 < patchfile
alias rm="rm -i"
alias tree="/usr/bin/tree --dirsfirst"
alias vi="vim"

[[ -f /usr/bin/time ]] && alias time="/usr/bin/time"

## locale issues
alias calibre="LC_ALL=en_US calibre"
alias git="LC_ALL=fr_FR@euro git"
alias glade="LC_ALL=en_US glade-3"
alias wicd-curses="LC_ALL=C wicd-curses"
## TERM issues
alias rxvt="urxvt"
alias rxvt-unicode="urxvt"

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
alias quickweb='python2 -m SimpleHTTPServer'
alias qweb='python3 -m http.server'
alias xpdf="okular"
#alias xpdf="qpdfview"
#alias xpdf="zathura"

#alias hd='od -Ax -tx1z -v'
#alias realpath='readlink -f'

function dirsize() {
    find ${*-.} -maxdepth 1 -type d -exec du -hs '{}' \;
}

function lsize() {
    du -b --max-depth 1 -- $* | sort -nr | perl -pe \
        's{([0-9]+)}{sprintf "%.1f%s", $1>=2**30? ($1/2**30, "G"): $1>=2**20? ($1/2**20, "M"): $1>=2**10? ($1/2**10, "K"): ($1, "")}e'
}

function histostats() {
    history | awk '{a[$2]++ } END{for(i in a){print a[i] " " i}}' | sort -rn | head
}

function font_test() {
    echo -e "      Alpha: ABCDEFGHIJKLMNOPQRSTUVWXYZ "
    echo -e "             abcdefghijklmnopqrstuvwxyz "
    echo -e "        Num: 0123456789 "
    echo -e "   Brackets: () [] {} <> "
    echo -e "     Quotes: \"foo\" 'bar' "
    echo -e "Punctuation: , . : ; _ ! ? "
    echo -e "    Symbols: ~  @ # $ % ^ & * - + = | / \` \\ "
    echo -e "  Ambiguity: iI1lL oO0 "
}

if [ -x "${HOME}/scripts/clippy.sh" ] ; then
    function command_not_found_handle { ${HOME}/scripts/clippy.sh $1 ; }
    export COWPATH="${HOME}/scripts/cows"
fi

shopt -s checkwinsize
shopt -s dotglob
shopt -s extglob
shopt -s histappend
shopt -s no_empty_cmd_completion
shopt -s globstar

export BROWSER="firefox '%s' &"
export CVS_RSH=/usr/bin/ssh
export DISPLAY=:0.0
export EDITOR=/usr/bin/vim
export FIGNORE=".svn:CVS"
export GREP_COLOR=32
export GREP_OPTIONS="--color=auto --exclude=tags --exclude=cscope.out --binary-files=without-match \
 --exclude-dir=CVS --exclude-dir=.bzr --exclude-dir=.git --exclude-dir=.hg --exclude-dir=.svn --exclude-dir=_darcs"
export HISTIGNORE="&:l:ll:ls:pwd:[bf]g:exit:clear:[ ]*"
export HISTSIZE=4096
export HISTFILESIZE=2097152
export JAVA_HOME=$(java-config -o)
export JAVAC="${JAVA_HOME}/bin/javac"
export LESS="$LESS --ignore-case"
export MANPAGER=vimmanpager
export PATH+=":${HOME}/scripts"
[[ -d "${HOME}/scripts/games" ]] && export PATH+=":${HOME}/scripts/games"

## bash 4: trim (nested) dirnames that are too long
#PROMPT_DIRTRIM=2

## For JOGL (it seems the default is missing ".so")
export EGL_DRIVER=/usr/lib/egl/egl_glx.so

## ooffice is veeery slow to start if the print server is unreachable
## (ServerName in /etc/cups/client.conf).  => set to any non-empty value.
export SAL_DISABLE_SYNCHRONOUS_PRINTER_DETECTION="a"

## Tell konsole it can use 256 colors. Konsole is not very smart.
[ -n "$KONSOLE_PROFILE_NAME" ] && export TERM=konsole-256color

## /usr/bin/time format (pass '-v' for exhaustive output)
export TIME="--\n%C  [exit %x]\nreal %e\tCPU: %P  \t\tswitches: %c forced, %w waits\nuser %U\tMem: %M kB maxrss\tpage faults: %F major, %R minor\nsys  %S\tI/O: %I/%O"

## VMware segfaults @work without this:
export VMWARE_USE_SHIPPED_GTK=force

## PROMPT_COMMAND : window title for X terminals
##            PS1 : shell prompt
if [[ ${EUID} == 0 ]] ; then
    c1='\[\033[00;31m\]'  # red
    c2='\[\033[01;31m\]'  # bold red
    id='\h'
    pr='#'
else
    c1='\[\033[00;34m\]'  # blue
    c2='\[\033[01;32m\]'  # bold green
    id='\u@\h'
    pr='$'
fi
c3='\[\033[01;34m\]'      # bold blue
cx='\[\033[00m\]'         # white
## Mix double quotes (for variables, must be expanded)
## and single quotes (for subshells, must not be expanded)
PS1="$c1\D{%m-%d %R} $c2$id $c3"'[`ls -1 | wc -l`]'" \W $pr $cx"
case $TERM in
	xterm*|rxvt*|konsole*)
		PROMPT_COMMAND='echo -ne "\033]0;${USER}@${HOSTNAME%%.*}:${PWD/$HOME/~}\007"'
		;;
	screen*)
		PROMPT_COMMAND='echo -ne "\033_${USER}@${HOSTNAME%%.*}:${PWD/$HOME/~}\033\\"'
        PS1="$cx(screen) $PS1"
		;;
esac
export PS1
unset c1 c2 c3 cx id pr

[[ -f /etc/profile.d/bash-completion ]]     && source /etc/profile.d/bash-completion
[[ -f /etc/profile.d/bash-completion.sh ]]  && source /etc/profile.d/bash-completion.sh
[[ -f /usr/share/compleat/compleat_setup ]] && source /usr/share/compleat/compleat_setup
[[ -f /usr/bin/ssh-askpass-fullscreen ]]    && export SUDO_ASKPASS=/usr/bin/ssh-askpass-fullscreen

