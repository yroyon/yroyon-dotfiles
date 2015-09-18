## This file should generate no output or it will break the scp | rcp commands.

. /etc/profile

## If not running interactively, don't do anything
[[ -t 1 ]] || return
#[[ -z $PS1 ]] && return
#[[ $- =~ i ]] || return

# ---------- detect OS {{{
name=$(uname -s)
if [ "$name" == "Darwin" ]; then
    os_mac=true
elif [ "$(expr substr $name 1 5)" == "Linux" ]; then
    os_linux=true
elif [ "$(expr substr $name 1 10)" == "MINGW32_NT" ]; then
    os_windows=true
fi
unset name
# }}}

# ---------- functions {{{
function dirsize() {
    find ${*-.} -maxdepth 1 -type d -exec du -hs '{}' \; 2>/dev/null
}

function lsize() {
    local du="du"
    [[ os_mac ]] && is_command "gdu" && du="gdu"
    ${du} -b --max-depth 1 -- $* 2>/dev/null | sort -nr | perl -pe \
        's{([0-9]+)}{sprintf "%.1f%s", $1>=2**30? ($1/2**30, "G"): $1>=2**20? ($1/2**20, "M"): $1>=2**10? ($1/2**10, "K"): ($1, "")}e'
}

function histostats() {
    history | awk '{a[$2]++ } END{for(i in a){print a[i] " " i}}' | sort -rn | head
}

function append_to_path() {
    if [[ -d "$1" ]] && [[ ! $PATH =~ (^|:)$1(:|$) ]] ; then
        PATH+=:$1
    fi
}

function prepend_to_path() {
    if [[ -d "$1" ]] && [[ ! $PATH =~ (^|:)$1(:|$) ]] ; then
        PATH=$1:$PATH
    fi
}

# usage: is_command go && echo "go is installed"
# works for functions, builtins, aliases, everything that 'type' can find.
function is_command() {
    $(type "$1" &> /dev/null)
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

if [[ -x ${HOME}/scripts/clippy.sh ]] ; then
    function command_not_found_handle { "${HOME}/scripts/clippy.sh" $1 ; }
    export COWPATH="${HOME}/scripts/cows"
fi
# }}}

# ---------- evals {{{
[[ $os_linux ]] && [[ -f ${HOME}/.dir_colors ]] && eval $(dircolors -b "${HOME}/.dir_colors")
[[ $os_mac   ]] && export CLICOLOR=1

# TODO ugly, and pdftotext not invoked porperly:
#[[ -x /usr/bin/lesspipe ]] && eval "$(SHELL=/bin/sh lesspipe)"

[[ -x /usr/bin/keychain ]] && eval $(keychain --eval --ignore-missing --quiet id_rsa id_rsa_eforge)
#/usr/bin/keychain $HOME/.ssh/id_rsa
#source $HOME/.keychain/$HOSTNAME-sh
# }}}

# ---------- aliases  {{{
## ls family new commands
[[ $os_linux ]] && ls_opts="--color --group-directories-first" && ls_sort="-X"
[[ $os_mac ]]   && ls_opts="-G"
alias      d="ls ${ls_opts}"
alias      l="ls ${ls_opts} ${ls_sort} -F"
alias     ll="ls ${ls_opts} ${ls_sort} -F -A -lh"
alias    lsa="ls ${ls_opts} ${ls_sort} -F -A"
alias    lsd="ls ${ls_opts} -d */"
alias llsize="ls ${ls_opts} -S         -F -A -lh"
alias  lsdir="tree -d -L 1 -i"
alias lsdirs="tree -d"
unset ls_opts ls_sort

## grep family new commands
# mac: brew tap homebrew/dupes; brew install grep
[[ $os_mac ]] && is_command "ggrep" && grep="ggrep" || grep="\grep"
alias grep="$grep --color=auto --exclude={tags,cscope.out} --binary-files=without-match --exclude-dir={CVS,.bzr,.git,.hg,.svn,_darcs}"
alias grepcode="grep -R --exclude=* --include=*.{c,C,cc,CC,cpp,h,H,hs,java,pl,properties,py,rb,s,S,scala,sh}"
alias grepdoc="grep -R --exclude=* --include=*.{adoc,asciidoc,bib,howto,info,markdown,md,text,txt,htm,html,rst,tex,todo,wip}"
alias grepbuild="grep -R --exclude=* --include=*.{ac,am,in,m4,mk,properties,sh,xml} --include={*akefile,*configure*,GNUmake*}"
alias grepwhite="grep '[[:space:]]\+$' -R"
alias g=grepcode
unset grep

## git family new commands
alias gdiff="git diff | vim - -R -c 'set filetype=git' -c 'set foldmethod=syntax'"
alias glog="git log -p $@ | vim - -R -c 'set foldmethod=syntax'"

## propagate (sub-)command completion when using sudo
alias sudo='sudo '

## default options to common commands
alias diff="colordiff -NrbB -x .git"
# Patching: git diff > patchfile  ;  patch -p1 < patchfile
alias rm="rm -i"
alias tree="tree --dirsfirst"
alias vi="vim"
[[ $os_mac ]] && {
    alias vi="mvim -v"
    alias vim="mvim"
}

[[ -x /usr/bin/time ]] && alias time="/usr/bin/time"
[[ -x /sbin/ifconfig ]] && alias ifconfig="/sbin/ifconfig"

## locale issues
alias calibre="LC_ALL=en_US calibre"
#alias git="LC_ALL=fr_FR@euro git"
alias glade="LC_ALL=en_US glade-3"
alias wicd-curses="LC_ALL=C wicd-curses"
## TERM issues
alias rxvt="urxvt"
alias rxvt-unicode="urxvt"

## colors
[[ -x /usr/bin/grc ]] && {
    alias cvs="grc cvs"
    alias netstat="grc netstat"
    alias ping="grc ping"
    alias svn="grc svn"
    alias traceroute="grc traceroute"
}

## new commands
alias dvdplay="mplayer -nocache dvdnav://"
alias emptytrash="rm -rf ~/.local/share/Trash/*"
alias loffice="libreoffice"
alias manga="thunar &>/dev/null &"
alias path='echo -e ${PATH//:/\\n}'
alias quickweb='python2 -m SimpleHTTPServer'
alias qweb='python3 -m http.server'
#alias suspend="pm-suspend"  # suspend is a bash builtin
alias xpdf="okular"
#alias xpdf="mupdf"
#alias xpdf="pdf-presenter-console"
#alias xpdf="pdfcube"
#alias xpdf="qpdfview"
#alias xpdf="zathura"

#alias hd='od -Ax -tx1z -v'
alias realpath='readlink -f'

## shortcut to KDE display settings (2nd monitor...)
[[ -x /usr/bin/kcmshell4 ]] && {
    alias kdisplay="kcmshell4 display"
    alias xdisplay="kcmshell4 display"
}
# }}}

# ---------- shopts {{{
shopt -s checkwinsize
shopt -s dotglob
shopt -s extglob
shopt -s histappend
shopt -s no_empty_cmd_completion
[[ $BASH_VERSION > 4 ]] && shopt -s globstar
# }}}

# ---------- environment {{{1
## FIGNORE is a list of *suffixes*, not exact matches. So abc.git/ will be filtered out!
#FIGNORE=".git:.svn:CVS"
HISTIGNORE="&:l:ll:ls:pwd:[bf]g:exit:clear:[ ]*"
HISTSIZE=4096
HISTFILESIZE=2097152

export BROWSER="firefox '%s' &"

export CVS_RSH=/usr/bin/ssh

[[ -z $DISPLAY ]] && export DISPLAY=:0.0

export EDITOR=/usr/bin/vim

export GREP_COLOR=32

case $(cat /etc/*release 2>/dev/null) in
    *Debian*) export JAVA_HOME=/usr/lib/jvm/default-java ;;
    *Gentoo*) export JAVA_HOME=$(java-config -o) ;;
    *) ;;
esac
[[ ! -z $JAVA_HOME ]] && export JAVAC="${JAVA_HOME}/bin/javac"

export MAVEN_OPTS="-Xmx1024m"
#export M2_HOME=/usr/local/maven
#export M2=$M2_HOME/bin

export LESS="$LESS --ignore-case --RAW-CONTROL-CHARS --squeeze-blank-lines"

export MANPAGER=vimmanpager

PATH+=":/sbin:/usr/sbin:/usr/local/sbin"
[[ -d ${HOME}/bin ]] && PATH+=":${HOME}/bin"
[[ -d ${HOME}/scripts ]] && PATH+=":${HOME}/scripts"
[[ -d ${HOME}/scripts/games ]] && PATH+=":${HOME}/scripts/games"
[[ -d $M2 ]] && PATH="$M2:$PATH"
export PATH

## bash 4: trim (nested) dirnames that are too long
#PROMPT_DIRTRIM=2

## For JOGL (it seems the default is missing ".so")
f="/usr/lib/egl/egl_glx.so"
[[ -f "$f" ]] && export EGL_DRIVER=$f

## ooffice is veeery slow to start if the print server is unreachable
## (ServerName in /etc/cups/client.conf).  => set to any non-empty value.
export SAL_DISABLE_SYNCHRONOUS_PRINTER_DETECTION="a"

## Tell konsole it can use 256 colors. Konsole is not very smart.
[[ -n $KONSOLE_PROFILE_NAME ]] && export TERM=konsole-256color

## /usr/bin/time format (pass '-v' for exhaustive output)
export TIME="--\n%C  [exit %x]\nreal %e\tCPU: %P  \t\tswitches: %c forced, %w waits\nuser %U\tMem: %M kB maxrss\tpage faults: %F major, %R minor\nsys  %S\tI/O: %I/%O"

## VMware segfaults @work without this:
export VMWARE_USE_SHIPPED_GTK=force

## Go lang: if present, set env
is_command go && {
    export GOROOT=$(go env GOROOT)
    export GOPATH="${HOME}/Source/go"
    mkdir -p "${GOPATH}"
}

f="/usr/bin/ssh-askpass"
[[ -x "$f" ]] && export SSH_ASKPASS="$f"
f="/usr/bin/ssh-askpass-fullscreen"
[[ -x "$f" ]] && export SUDO_ASKPASS="$f"
# See http://forums.gentoo.org/viewtopic-t-925016-start-0.html

# ---------- ---------- Prompts {{{2
## PROMPT_COMMAND : window title for X terminals
##            PS1 : shell prompt
if [[ $EUID == 0 ]] ; then
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
[[ $os_linux ]] && PS1="$c1\D{%m-%d %R} $c2$id $c3"'[`ls -1 | wc -l`]'" \W $pr $cx"
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
# }}}2 }}}1

# ---------- readline {{{
## PageUp and PageDown browse through bash history
bind '"\e[5~": history-search-backward'
bind '"\e[6~": history-search-forward'
# }}}

# ---------- sources {{{
for src in \
    /etc/profile.d/proxy.sh \
    /etc/profile.d/bash-completion \
    /etc/profile.d/bash-completion.sh \
    /usr/share/compleat/compleat_setup \
    ${HOME}/.bash-powerline.sh \
    ${HOME}/.iterm2_shell_integration.bash \
; do
    [[ -f $src ]] && source "$src"
done
[[ $os_mac ]] && is_command brew && {
    f="$(brew --prefix)/etc/bash_completion"
    [[ -f $f ]] && source "$f"
}
# }}}

unset f d

# vim: fdm=marker
