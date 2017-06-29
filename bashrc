## This file should generate no output or it will break the scp | rcp commands.

. /etc/profile

## If not running interactively, don't do anything
[[ -t 1 ]] || return
#[[ -z $PS1 ]] && return
#[[ $- =~ i ]] || return

[[ $TERM == nuclide ]] && return

## profile
#PS4='+ $(date "+%s.%N")\011 '
#exec 3>&2 2>/tmp/bashstart.$$.log
#set -x
##

# ---------- detect OS {{{
name=$(uname -s)
if [[ $name == Darwin ]]; then
    os_mac=true
elif [[ $name =~ Linux ]]; then
    os_linux=true
    os_gnu=true
elif [[ $name =~ MINGW32_NT ]]; then
    os_windows=true
fi
unset name
# }}}

# ---------- functions {{{
# List directory sizes, unsorted
# (see lsize for sorted version)
function dirsize() {
    find "${@-.}" -maxdepth 1 -type d -exec du -hs '{}' \; 2>/dev/null
}

du_sorted () {
    local ds="${@-.}"
    paste -d '#' <(du $ds) <(du -h $ds) | sort -n -k1,7 | cut -d '#' -f 2
}

# TODO
#unhuman() {
#   numfmt --from=auto --to-unit=K
#}
# sum:
# awk '{print $2}' < montana.by_size | numfmt --from=auto --to-unit=1M | paste -sd+ | bc | numfmt --to-unit=1K

function test_font() {
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

function histostats() {
    history | awk '{a[$2]++} END {for(i in a) {print a[i] " " i}}' | sort -rn | head -n ${1-10}
}

# usage: is_command go && echo "go is installed"
# works for functions, builtins, aliases, everything that 'type' can find.
function is_command() {
    type "$1" &> /dev/null
}

# Add $1 to end of PATH. Remove duplicates.
function path_append() {
    if [[ -d "$1" ]] ; then
        path_remove $1
        PATH+=:$1
    fi
}

# Add $1 to beginning of PATH. Remove duplicates.
function path_prepend() {
    if [[ -d "$1" ]] ; then
        path_remove $1
        PATH=$1:$PATH
    fi
}

function path_remove() {
    # remove $1 at beginning | end | middle of PATH. If middle, keep ':'
    PATH=$(echo "$PATH" | sed -e "s|^$1:||" | sed -e "s|:$1$||" | sed -e "s|:$1:|:|")
}

function rot13() {
    tr A-Za-z N-ZA-Mn-za-m
}

# Reverse diff: print identical parts of 2+ files
# Contrary to comm(1), files do not need to be sorted
function samelines() {
    perl -ne 'print if ($seen{$_} .= @ARGV) =~ /10$/' "$@"
}

# Git
function gdiff() {
    git diff "$@" | vim - -R -c 'set filetype=git' -c 'set foldmethod=syntax'
}

function glog() {
    git log -p "$@" | vim - -R -c 'set foldmethod=syntax'
}

# Docker
is_command docker-machine && {
    function docker-enable() {
        eval "$(docker-machine env default)"
    }
}

is_command docker && {

    function docker-cleanup-containers() {
        echo "Clean up exited containers..."
        # !!! rm -v will nuke volume containers
        docker ps --all --quiet -f status=exited | xargs -P4 --no-run-if-empty docker rm
    }

    function docker-cleanup-images() {
        echo "Clean up unused images..."
        docker images --quiet --filter "dangling=true" | xargs -P4 --no-run-if-empty docker rmi
    }

    function docker-cleanup-volumes() {
        echo "Clean up unused volumes..."
        docker volume ls --quiet -f dangling=true | xargs -P4 --no-run-if-empty docker volume rm
    }

    function docker-cleanup-overlays() {
        echo "Clean up overlay[fs]..."
        pushd /var/lib/docker/overlay/ &>/dev/null && {
            for o in *; do
                docker inspect $(docker ps -aq) | grep $o &>/dev/null || rm -rf $o
            done
            popd &>/dev/null
        }
    }

    function docker-cleanup() {
        docker-cleanup-containers
        docker-cleanup-images
        docker-cleanup-volumes
        docker-cleanup-overlays
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

# List directories by size
# Use nicest 'du' and 'sort' available
if [[ $os_mac ]] && is_command "gdu"; then
    # MacOS using GNU coreutils
    function lsize() {
        gdu -h --max-depth 1 "$@" 2>/dev/null | gsort -hr
    }
elif [[ $os_mac ]]; then
    # MacOS using BSD base system
    # Show kilobytes :-(
    function lsize() {
        du -d 1 -k "$@" | sort -gr
    }
else
    # GNU/Linux
    function lsize() {
        du -h --max-depth 1 "$@" 2>/dev/null | sort -hr
    }
fi

# MacOS: if Finder window open, cd the shell into that directory
[[ $os_mac ]] && {
    function cdf() {
        local target
        target=$(osascript -e 'tell application "Finder" to if (count of Finder windows) > 0 then get POSIX path of (target of front Finder window as text)')
        if [[ $target != "" ]]; then
            cd "$target"; pwd
        else
            echo 'No Finder window found' >&2
        fi
    }
}

[[ $os_linux ]] && alias realpath='readlink -f'
[[ $os_mac ]] && function realpath() { (cd -P -- "${1:-.}" && pwd) }
# realpath() { perl -MCwd=abs_path -le 'print abs_path readlink(shift);' "$1"; }

# Basic computations, e.g.: calc 35.7 / 8
if is_command python3; then
    function calc() {
        echo "print($*)" | python3
    }
elif is_command ruby; then
    function calc() {
        echo "puts $*" | ruby
    }
elif is_command python2; then
    function calc() {
        echo " print $*" | python2
    }
fi

if [[ -x ${HOME}/bin/clippy.sh ]] ; then
    function command_not_found_handle() { "${HOME}/bin/clippy.sh" "$1" ; }
    export COWPATH="${HOME}/bin/cows"
fi
# }}}

# ---------- path  {{{
path_append "/usr/local/sbin"
path_append "/usr/sbin"
path_append "/sbin"
path_append "/opt/bin"
# MacOS with 'brew install coreutils':
d="/usr/local/opt/coreutils/libexec/gnubin"
[[ -d $d ]] && {
    path_prepend "$d"
    os_gnu=true
}
unset d
# Maven
path_prepend "${M2}"
# Rust
path_prepend "${HOME}/.cargo/bin"
# My stuff
path_prepend "${HOME}/bin"
path_prepend "${HOME}/scripts"
path_append "${HOME}/scripts/games"
export PATH
# }}}

# ---------- evals {{{
[[ $os_gnu ]] && [[ -f ${HOME}/.dir_colors ]] && eval "$(dircolors -b "${HOME}/.dir_colors")"
[[ $os_mac ]] && export CLICOLOR=1

is_command ssh-agent && [[ -z $(pidof ssh-agent) ]] && eval "$(ssh-agent -s)"
is_command keychain && eval "$(keychain --eval --ignore-missing --quiet id_rsa verizon_atlassian)"

# https://github.com/nvbn/thefuck
is_command thefuck && eval "$(thefuck --alias)"

# TODO ugly, and pdftotext not invoked porperly:
#is_command lesspipe && eval "$(SHELL=/bin/sh lesspipe)"
# }}}

# ---------- environment {{{1
## FIGNORE is a list of *suffixes*, not exact matches. So abc.git/ will be filtered out!
#FIGNORE=".git:.svn:CVS"
HISTIGNORE="&:l:ll:ls:pwd:[bf]g:exit:clear:[ ]*"
HISTSIZE=8192
HISTFILESIZE=2097152

export BROWSER="firefox '%s' &"
export CVS_RSH=/usr/bin/ssh
export EDITOR=/usr/bin/vim
export GREP_COLOR=32
export LESS="--ignore-case --RAW-CONTROL-CHARS --squeeze-blank-lines"

[[ $os_mac ]] && export HOMEBREW_NO_ANALYTICS=1

is_command vimmanpager && export MANPAGER=vimmanpager
# For Mac OS X with 'brew install coreutils':
#d="/usr/local/opt/coreutils/libexec/gnuman"
#[[ -d "$d" ]] && export MANPATH="$d:$MANPATH"

## bash 4: trim (nested) dirnames that are too long
#PROMPT_DIRTRIM=2

## ooffice is veeery slow to start if the print server is unreachable
## (ServerName in /etc/cups/client.conf).  => set to any non-empty value.
#export SAL_DISABLE_SYNCHRONOUS_PRINTER_DETECTION="a"

## TERM setting.
## Tell konsole it can use 256 colors. Konsole is not very smart.
#[[ -n $KONSOLE_PROFILE_NAME ]] && export TERM=konsole-256color
# The konsole TERM is racist. It won't show colors as root. Pretend to be xterm.
[[ $EUID == 0 ]] && export TERM=xterm-256color

is_command hh && export HH_CONFIG=hicolor

## /usr/bin/time format (pass '-v' for exhaustive output)
export TIME="--\n%C  [exit %x]\nreal %e\tCPU: %P  \t\tswitches: %c forced, %w waits\nuser %U\tMem: %M kB maxrss\tpage faults: %F major, %R minor\nsys  %S\tI/O: %I/%O"

## VMware segfaults @work without this:
#export VMWARE_USE_SHIPPED_GTK=force

[[ -z $DISPLAY ]] && export DISPLAY=:0.0

# Java, Maven
export JAVA_HOME
export JAVAC
case $(cat /etc/*release 2>/dev/null) in
    *Debian*) JAVA_HOME=/usr/lib/jvm/default-java ;;
    *Gentoo*) JAVA_HOME=$(java-config -o) ;;
    *Ubuntu*) JAVA_HOME=$(readlink -f /usr/bin/javac | sed "s:/bin/javac::") ;;
    *) ;;
esac
[[ -n $JAVA_HOME ]] && JAVAC="${JAVA_HOME}/bin/javac"
export MAVEN_OPTS="-Xmx1024m"

# Golang
is_command go && {
    export GOROOT
    GOROOT=$(go env GOROOT)
    if [[ $EUID != 0 ]] ; then
        GOPATH="$HOME/code/go"
        export GOPATH
        mkdir -p "$GOPATH"
        path_append "$GOPATH/bin"
    fi
    #path_append $GOROOT
}

# TODO clang/llvm on macOS
# Using the bundled libc++:
#    LDFLAGS="-L/usr/local/opt/llvm/lib -Wl,-rpath,/usr/local/opt/llvm/lib"
# Using the brew-provided LLVM instead of MacOS-shipped one:
#    LDFLAGS:  -L/usr/local/opt/llvm/lib
#    CPPFLAGS: -I/usr/local/opt/llvm/include

# SSH
f="/usr/bin/ssh-askpass"
[[ -x "$f" ]] && export SSH_ASKPASS="$f"
f="/usr/bin/ssh-askpass-fullscreen"
[[ -x "$f" ]] && export SUDO_ASKPASS="$f"
# See http://forums.gentoo.org/viewtopic-t-925016-start-0.html

# The useful shellcheck static analyzer:
# Ignore Useless Use Of Cat
export SHELLCHECK_OPTS='--shell=bash --exclude=SC2002'
# }}}

# ---------- aliases  {{{
## ls family new commands
[[ $os_gnu ]] && ls_opts="--color --group-directories-first" && ls_sort="-Xv"
[[ $os_mac ]] && [[ ! $os_gnu ]] && ls_opts="-G"
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
[[ $os_mac ]] && is_command "ggrep" && grep="ggrep --color=auto" || grep="\grep --color=auto"
alias grep="$grep --color=auto --exclude={tags,cscope.out} --binary-files=without-match --exclude-dir={CVS,.bzr,.git,.hg,.svn,_darcs}"
alias grepcode="$grep -R --exclude=* --include=*.{c,C,cc,CC,cpp,h,H,hs,java,pl,properties,py,rb,s,S,scala,sh}"
alias grepdoc="$grep -R --exclude=* --include=*.{adoc,asciidoc,bib,howto,info,markdown,md,text,txt,htm,html,rst,tex,todo,wip}"
alias grepbuild="$grep -R --exclude=* --include=*.{ac,am,in,m4,mk,properties,sh,xml} --include={*akefile,*configure*,GNUmake*}"
alias grepwhite="$grep '[[:space:]]\+$' -R"
alias g=grepcode
unset grep

function grepport() {
    [[ $1 =~ ^[0-9]+$ ]] || {
        echo "$1 is not a valid port number"
        return 1
    }
    lsof -n -iTCP:$1
}

# TODO
# 'route' for MacOS:
# netstat -nr

## GNU xargs supports --no-run-if-empty
[[ $os_mac ]] && [[ $os_gnu ]] && {
    is_command gsed && alias sed=gsed
    is_command gxargs && alias xargs=gxargs
}

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

# Inhibit "non-prefixed coreutils" warning from `brew doctor`
[[ $os_mac ]] && {
    alias brew="PATH=/usr/local/bin:/usr/bin:/bin:/usr/local/sbin:/usr/sbin:/sbin /usr/local/bin/brew"
}

# GNU parallel
#is_command parallel && alias parallel="parallel --will-cite"

[[ -x /usr/bin/time ]] && alias time="/usr/bin/time"
[[ $os_mac ]] && [[ $os_gnu ]] && is_command gtime && alias time=gtime
[[ -x /sbin/ifconfig ]] && alias ifconfig="/sbin/ifconfig"
[[ -x /usr/libexec/locate.updatedb ]] && alias updatedb="sudo /usr/libexec/locate.updatedb"

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
alias emptytrash="rm -rf ~/.local/share/Trash/*; rm -rf ~/.Trash/*"
alias loffice="libreoffice"
alias manga="thunar &>/dev/null &"
alias path='echo -e ${PATH//:/\\n}'
alias quickweb='python2 -m SimpleHTTPServer'
alias qweb='python3 -m http.server'
#alias suspend="pm-suspend"  # suspend is a bash builtin

## colorized cat
# 'ccat' conflicts with package ccrypt, which I don't use so far.
# Pick one of these tools, most preferred first.
#   - speed: ccat > src-hilite-lesspipe.sh (x2) >>> vimcat (x30) >>> pygmentize (x60)
#   - pygmentize takes only one file parameter.
#     src-hilite-lesspipe.sh takes many, prints with no visual separator.
#     ccat same.
#     vimcat takes many, prints with visual separator.
if is_command pygmentize; then
    # 'pip3 install Pygments':
    ccat() {
        # Simulate support for multiple files in argument
        for f in "$@"; do
            # Show file name like vimcat does
            [[ $# -gt 1 ]] && echo "==> $f <=="
            # Suggested color schemes: emacs fruity monokai perldoc
            pygmentize -O style=emacs -f console256 -g "$f"
        done
    }
elif is_command ccat; then
    # from package ccat:
    alias ccat='ccat --bg=dark'
elif is_command vimcat; then
    # from package vimpager:
    alias ccat='vimcat'
elif is_command src-hilite-lesspipe.sh; then
    # from package source-highlight:
    alias ccat='src-hilite-lesspipe.sh'
#elif is_command lesspipe.sh; then
    # fom package lesspipe: color doesn't work for me following man page
    #alias ccat='lesspipe.sh'
fi

# TODO try out 'mdv' to view Markdown

[[ $os_linux ]] && {
    # ordered, most favorite first
    pdf_readers="okular mupdf pdf-presenter-console zathura pdfcube qpdfview"
    for reader in ${pdf_readers}; do
        is_command "$reader" && alias xpdf="$reader" && break
    done
    unset reader pdf_readers
}
[[ $os_mac ]] && alias xpdf="open"

#alias hd='od -Ax -tx1z -v'

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

# ---------- ansi colors {{{
export c_black='\033[0;30m'
export c_red='\033[0;31m'
export c_green='\033[0;32m'
export c_yellow='\033[0;33m'
export c_blue='\033[0;34m'
export c_purple='\033[0;35m'
export c_cyan='\033[0;36m'
export c_gray='\033[0;37m'
export c_bold_gray='\033[1;30m'
export c_bold_red='\033[1;31m'
export c_bold_green='\033[1;32m'
export c_bold_yellow='\033[1;33m'
export c_bold_blue='\033[1;34m'
export c_bold_purple='\033[1;35m'
export c_bold_cyan='\033[1;36m'
export c_bold_white='\033[1;37m'
export c_none='\033[00m'

function test_colors() {
  echo -e "$c_none no color"
  echo -n -e "$c_black black\t$c_red red\t$c_green green\t$c_yellow yellow"
  echo -e "\t$c_blue blue\t$c_purple purple\t$c_cyan cyan\t$c_gray gray"
  echo -n -e "$c_bold_gray gray2\t$c_bold_red red2\t$c_bold_green green2\t$c_bold_yellow yellow2"
  echo -e "\t$c_bold_blue blue2\t$c_bold_purple purple2\t$c_bold_cyan cyan2\t$c_bold_white white2"
}
# }}}

# ---------- prompts {{{
## PROMPT_COMMAND : window title for X terminals
##            PS1 : shell prompt
if [[ $EUID == 0 ]] ; then
    c1="\[${c_red}\]"     # colors in PS1 must be surrounded by escaped brackets
    c2="\[${c_bold_red}\]"
    id='\h'               # identifier part
    pr='#'                # prompt symbol
else
    c1="\[${c_blue}\]"
    c2="\[${c_bold_green}\]"
    id='\u@\h'            # identifier part
    pr='$'                # prompt symbol
fi
c3="\[${c_bold_blue}\]"
cx="\[${c_none}\]"

## Mix double quotes (for variables, must be expanded now)
## and single quotes (for subshells, must not be expanded until prompt is evaluated)
[[ $os_linux ]] && PS1="${c1}\D{%m-%d %R} ${c2}${id} ${c3}["'$(ls -1 | wc -l)'"] \W $pr $cx"
[[ $os_mac ]] && PS1="${c2}\u ${c3}["'$(ls -1 | gwc -l)'"] \W $pr $cx"

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
# PROMPT_COMMAND="history -a; history -n; ${PROMPT_COMMAND}"
# }}}

# ---------- readline {{{
## PageUp and PageDown browse through bash history
bind '"\e[5~": history-search-backward'
bind '"\e[6~": history-search-forward'
## Ctrl-r invokes https://github.com/dvorka/hstr
is_command hh && bind '"\C-r": "\C-ahh -- \C-j"'
# }}}

# ---------- sources {{{
# Note: iterm's bash integration makes debugging with 'bash -x' very noisy
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
    # Note: brew's bash_completion makes bash start very slow
    f="$(brew --prefix)/etc/bash_completion"
    [[ -f $f ]] && source "$f"
    [[ $BASH_VERSION > 4 ]] && {
        # Tip: replace function _have() with 'true'. Will load more things, but faster.
        f="$(brew --prefix)/share/bash-completion/bash_completion"
        [[ -f $f ]] && source "$f"
    }
}
# }}}

unset f d

## end profile
#set +x
#exec 2>&3 3>&-
##

# vim: fdm=marker
