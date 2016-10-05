## This file should generate no output or it will break the scp | rcp commands.

. /etc/profile

## If not running interactively, don't do anything
[[ -t 1 ]] || return
#[[ -z $PS1 ]] && return
#[[ $- =~ i ]] || return

[[ $TERM == nuclide ]] && return

# ---------- detect OS {{{
name=$(uname -s)
if [ "$name" == "Darwin" ]; then
    os_mac=true
elif [ "$(expr substr $name 1 5)" == "Linux" ]; then
    os_linux=true
    os_gnu=true
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
    local sort="sort"
    [[ $os_mac ]] && {
        is_command "gdu" && du="gdu"
        is_command "gsort" && sort="gsort"
    }
    ${du} -h --max-depth 1 $* 2>/dev/null | ${sort} -hr
}

function histostats() {
    history | awk '{a[$2]++ } END{for(i in a){print a[i] " " i}}' | sort -rn | head
}

function path_append() {
    if [[ -d "$1" ]] && [[ ! $PATH =~ (^|:)$1(:|$) ]] ; then
        PATH+=:$1
    fi
}

function path_prepend() {
    if [[ -d "$1" ]] && [[ ! $PATH =~ (^|:)$1(:|$) ]] ; then
        PATH=$1:$PATH
    fi
}

function path_remove() {
    # remove $1 at beginning | end | middle of PATH
    PATH=$(echo $PATH | sed -e "s|^$v:||" | sed -e "s|:$v$||" | sed -e "s|:$v:|:|")
}

# usage: is_command go && echo "go is installed"
# works for functions, builtins, aliases, everything that 'type' can find.
function is_command() {
    $(type "$1" &> /dev/null)
}

# Docker
is_command docker-machine && {
    function docker-enable() {
        eval $(docker-machine env default)
    }
}
is_command docker && {
    function docker-rmi-dangling() {
        docker images --quiet --filter "dangling=true" | xargs docker rmi
    }
    function docker-pull-all() {
        docker images | awk '/^REPOSITORY|\<none\>/ {next} {print $1":"$2}' | xargs -n 1 docker pull
    }
    function docker-ip() {
        docker inspect --format '{{ .NetworkSettings.IPAddress }}' "$@"
    }
}

# Python
is_command pip3 && {
    function pip3-upgrade() {
        pip3 freeze --local | grep -v '^\-e' | cut -d = -f 1 | xargs -n1 pip3 install -U
    }
}

function font_test() {
    echo -e "      Alpha: ABCDEFGHIJKLMNOPQRSTUVWXYZ "
    echo -e "             abcdefghijklmnopqrstuvwxyz "
    echo -e "        Num: 0123456789 "
    echo -e "   Brackets: () [] {} <> "
    echo -e "     Quotes: \"double\" 'single' \`back\`"
    echo -e "Punctuation: , . : ; _ ! ? "
    echo -e "    Symbols: ~ @ # $ % ^ & * - + = / | \\ "
    echo -e "  Ambiguity: iI1lL oO0 "
    echo -e "     French: á à â Â é è ê É î ï Î ô ö Ô û ü ç"
    echo -e "      Fancy: æ œ ñ ø € ¢ ©  “”„ ‘’ … ¿ ‹› ‡"
    echo -e "       Math: Ω ∑ ß ∂ ƒ ∆ π µ √ ∫ ∞ ≈ ≠ ≤ ≥ ÷ ± —"
}

if [[ -x ${HOME}/bin/clippy.sh ]] ; then
    function command_not_found_handle { "${HOME}/bin/clippy.sh" $1 ; }
    export COWPATH="${HOME}/bin/cows"
fi
# }}}

# ---------- path  {{{
path_append "/sbin"
path_append "/usr/sbin"
path_append "/usr/local/sbin"
path_append "/opt/bin"
path_append "${HOME}/bin"
path_append "${HOME}/scripts"
path_append "${HOME}/scripts/games"
path_prepend "${M2}"
# For Mac OS X with 'brew install coreutils':
d="/usr/local/opt/coreutils/libexec/gnubin"
[[ -d $d ]] && {
    path_prepend $d
    os_gnu=true
}
unset d
export PATH
# }}}

# ---------- evals {{{
[[ $os_gnu ]] && [[ -f ${HOME}/.dir_colors ]] && eval $(dircolors -b "${HOME}/.dir_colors")
[[ $os_mac ]] && export CLICOLOR=1

is_command ssh-agent && [[ -z $(pidof ssh-agent) ]] && eval $(ssh-agent -s)
is_command keychain && eval $(keychain --eval --ignore-missing --quiet id_rsa id_rsa_eforge)

# https://github.com/nvbn/thefuck
is_command thefuck && eval $(thefuck --alias)

# TODO ugly, and pdftotext not invoked porperly:
#is_command lesspipe && eval "$(SHELL=/bin/sh lesspipe)"
# }}}

# ---------- environment {{{1
## FIGNORE is a list of *suffixes*, not exact matches. So abc.git/ will be filtered out!
#FIGNORE=".git:.svn:CVS"
HISTIGNORE="&:l:ll:ls:pwd:[bf]g:exit:clear:[ ]*"
HISTSIZE=4096
HISTFILESIZE=2097152

export BROWSER="firefox '%s' &"
export CVS_RSH=/usr/bin/ssh
export EDITOR=/usr/bin/vim
export GREP_COLOR=32
export LESS="$LESS --ignore-case --RAW-CONTROL-CHARS --squeeze-blank-lines"

is_command vimmanpager && export MANPAGER=vimmanpager
# For Mac OS X with 'brew install coreutils':
#d="/usr/local/opt/coreutils/libexec/gnuman"
#[[ -d "$d" ]] && export MANPATH="$d:$MANPATH"

## bash 4: trim (nested) dirnames that are too long
#PROMPT_DIRTRIM=2

## For JOGL (it seems the default is missing ".so")
f="/usr/lib/egl/egl_glx.so"
[[ -f "$f" ]] && export EGL_DRIVER=$f

## ooffice is veeery slow to start if the print server is unreachable
## (ServerName in /etc/cups/client.conf).  => set to any non-empty value.
export SAL_DISABLE_SYNCHRONOUS_PRINTER_DETECTION="a"

## TERM setting.
## Tell konsole it can use 256 colors. Konsole is not very smart.
#[[ -n $KONSOLE_PROFILE_NAME ]] && export TERM=konsole-256color
# The konsole TERM is racist. It won't show colors as root. Pretend to be xterm.
[[ $EUID == 0 ]] && export TERM=xterm-256color

## /usr/bin/time format (pass '-v' for exhaustive output)
export TIME="--\n%C  [exit %x]\nreal %e\tCPU: %P  \t\tswitches: %c forced, %w waits\nuser %U\tMem: %M kB maxrss\tpage faults: %F major, %R minor\nsys  %S\tI/O: %I/%O"

## VMware segfaults @work without this:
export VMWARE_USE_SHIPPED_GTK=force

[[ -z $DISPLAY ]] && export DISPLAY=:0.0

# Java, Maven
case $(cat /etc/*release 2>/dev/null) in
    *Debian*) export JAVA_HOME=/usr/lib/jvm/default-java ;;
    *Gentoo*) export JAVA_HOME=$(java-config -o) ;;
    *Ubuntu*) export JAVA_HOME=$(readlink -f /usr/bin/javac | sed "s:/bin/javac::") ;;
    *) ;;
esac
[[ ! -z $JAVA_HOME ]] && export JAVAC="${JAVA_HOME}/bin/javac"
export MAVEN_OPTS="-Xmx1024m"
#export M2_HOME=/usr/local/maven
#export M2=$M2_HOME/bin

# Go lang: if present, set env
is_command go && {
    export GOROOT=$(go env GOROOT)
    if [[ $EUID != 0 ]] ; then
        export GOPATH="${HOME}/code/go"
        mkdir -p "${GOPATH}"
    fi
}

# SSH
f="/usr/bin/ssh-askpass"
[[ -x "$f" ]] && export SSH_ASKPASS="$f"
f="/usr/bin/ssh-askpass-fullscreen"
[[ -x "$f" ]] && export SUDO_ASKPASS="$f"
# See http://forums.gentoo.org/viewtopic-t-925016-start-0.html
# }}}

# ---------- aliases  {{{
## ls family new commands
[[ $os_gnu ]] && ls_opts="--color --group-directories-first" && ls_sort="-X"
[[ $os_mac   ]] && [[ ! $os_gnu ]] && ls_opts="-G"
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

## GNU xargs supports --no-run-if-empty
[[ $os_mac ]] && [[ $os_gnu ]] && {
    alias sed=gsed
    alias xargs=gxargs
}

## git family new commands
alias gdiff="git diff | vim - -R -c 'set filetype=git' -c 'set foldmethod=syntax'"
alias glog="git log -p $@ | vim - -R -c 'set foldmethod=syntax'"

## propagate (sub-)command completion when using sudo
alias sudo='sudo '

## default options to common commands
is_command colordiff && diffprog="colordiff" || diffprog="diff"
alias diff="$diffprog -NrbB -x .git"
unset diffprog
alias rm="rm -i --one-file-system"
[[ $os_mac ]] && alias pstree="pstree -w -g3"
[[ $os_mac ]] && {
    alias tree="tree --dirsfirst -C"
} || {
    alias tree="tree --dirsfirst"
}
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
is_command grc && {
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

[[ $os_linux ]] && {
    # ordered, most favorite first
    pdf_readers="okular mupdf pdf-presenter-console zathura pdfcube qpdfview"
    for reader in ${pdf_readers}; do
        is_command $reader && alias xpdf=$reader && break
    done
    unset reader pdf_readers
}
[[ $os_mac ]] && alias xpdf="open"

#alias hd='od -Ax -tx1z -v'
alias realpath='readlink -f'

## shortcut to KDE display settings (2nd monitor...)
is_command kcmshell4 && {
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

# ---------- prompts {{{
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
[[ $os_mac ]] && PS1="$c2\u $c3"'[`ls -1 | gwc -l`]'" \W $pr $cx"
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
# }}}

# ---------- readline {{{
## PageUp and PageDown browse through bash history
bind '"\e[5~": history-search-backward'
bind '"\e[6~": history-search-forward'
# }}}

# ---------- sources {{{
for f in \
    /etc/profile.d/proxy.sh \
    /etc/profile.d/bash-completion \
    /etc/profile.d/bash-completion.sh \
    /usr/share/compleat/compleat_setup \
    ${HOME}/.bash-powerline.sh \
    ${HOME}/.iterm2_shell_integration.bash \
; do
    [[ -f $f ]] && source "$f"
done
[[ $os_mac ]] && is_command brew && {
    f="$(brew --prefix)/etc/bash_completion"
    [[ -f $f ]] && source "$f"
}

unset f d
# }}}

# vim: fdm=marker
