# vim: fdm=marker

# shellcheck disable=SC2139
# SC2139: expand when defined, not when used.  It's mostly what I want, but it still caught a bug.
#         Disable now; re-enable the warning once in a while to revisit.

## This file should generate no output or it will break the scp | rcp commands.

. /etc/profile

## If not running interactively, don't do anything
[[ -t 1 ]] || return
#[[ -z $PS1 ]] && return
#[[ $- =~ i ]] || return

[[ $TERM == nuclide ]] && return

## profiling
#PS4='+ $(date "+%s.%N")\011 '
#exec 3>&2 2>/tmp/bashstart.$$.log
#set -x
##

# ---------- detect OS {{{
name=$(uname -s)
if [[ $name == Darwin ]]; then
    os_mac=true
    # detect os_gnu later, in the 'path' section of this file
elif [[ $name =~ Linux ]]; then
    os_linux=true
    os_gnu=true
elif [[ $name =~ MINGW32_NT ]]; then
    # shellcheck disable=SC2034  # unused
    os_windows=true
fi
unset name
# }}}

# ---------- functions {{{
# List directory sizes, unsorted
# (see lsize for sorted version)
function dirsize() {
    find "${@-.}" -maxdepth 1 -type "d" -exec du -hs '{}' \; 2>/dev/null
}

function du_sorted() {
    paste -d '#' <(du "${@}") <(du -h "${@}") | sort -n -k1,7 | cut -d '#' -f 2
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
    echo -e "   Brackets: () [] {} <-> "
    echo -e "     Quotes: \"double\" 'single' \`back\`"
    echo -e "Punctuation: , . : ; _ ! ? "
    echo -e "    Symbols: ~ @ # $ % ^ & * - + = / | \\ "
    echo -e "  Ambiguity: iI1lL oO0 "
    echo -e "     French: á à â Â é è ê É î ï Î ô ö Ô û ü ç"
    # shellcheck disable=SC1111  # silly warning
    echo -e "      Fancy: æ œ ñ ø € ¢ ©  “”„ ‘’ … ¿ ‹› ‡"
    echo -e "       Math: Ω ∑ ß ∂ ƒ ∆ π µ √ ∫ ∞ ≈ ≠ ≤ ≥ ÷ ± —"
}

# Most used commands in my bash sessions.
# Top 10 by default, pass a number for Top N.
function histostats() {
    # If not using timestamps (default), index is $2
    # If using timestamps, index is $4 (depending on your HISTTIMEFORMAT)
    history | awk '{a[$4]++} END {for(i in a) {print a[i] " " i}}' | sort -rn | head -n "${1-10}"
}

# usage: is_command go && echo "go is installed"
# works for functions, builtins, aliases, everything that 'type' can find.
function is_command() {
    type -t "$1" &> /dev/null
}

# Add $1 to end of PATH. Remove duplicates.
function path_append() {
    if [[ -d "$1" ]] ; then
        path_remove "$1"
        PATH+=:$1
    fi
}

# Add $1 to beginning of PATH. Remove duplicates.
function path_prepend() {
    if [[ -d "$1" ]] ; then
        path_remove "$1"
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

# Print a horizontal rule.  $1 is optional override of the rule character.
function rule() {
	printf -v _hr "%*s" "$(tput cols)" && echo "${_hr// /${1-─}}"
}

function rule_msg()  {
	if [ $# -eq 0 ]; then
		echo "Usage: ${FUNCNAME[0]} MESSAGE [RULE_CHARACTER]"
		return 1
	fi
	# Fill line with ruler character, reset cursor, move 2 cols right, print message
	printf -v _hr "%*s" "$(tput cols)" && echo -en "${_hr// /${2-─}}" && echo -e "\r\033[2C$1"
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
        docker ps --all --quiet -f status=exited | xargs -P4 --no-run-if-empty docker "rm"
    }

    function docker-cleanup-images() {
        echo "Clean up unused images..."
        docker images --quiet --filter "dangling=true" | xargs -P4 --no-run-if-empty docker rmi
    }

    function docker-cleanup-volumes() {
        echo "Clean up unused volumes..."
        docker volume ls --quiet -f dangling=true | xargs -P4 --no-run-if-empty docker volume "rm"
    }

    function docker-cleanup() {
        docker-cleanup-containers
        docker-cleanup-images
        docker-cleanup-volumes
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
        pip3 freeze --local | grep -v '^\-e' | cut -d = -f 1 | xargs -n1 pip3 install -U -q
    }
}
is_command pip2 && {
    function pip2-upgrade() {
        pip2 freeze --local | grep -v '^\-e' | cut -d = -f 1 | xargs -n1 pip2 install -U -q --no-python-version-warning
    }
}

# Python3 on Mac
[[ -f /usr/local/bin/python3 ]] && {
    alias python=/usr/local/bin/python3
}
[[ -f /usr/local/bin/pip3 ]] && {
    alias pip=/usr/local/bin/pip3
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

# Consume stdin and spit it out at some rate-limited time interval.
# Uses date(1) and bash arithmetics.
# The time unit is seconds -- not anything smaller (that I can find).
debounce() {
    local -i intervalInSeconds
    local -i limit
    [[ -z $1 ]] && {
        echo >&2 "Usage: ${FUNCNAME[0]} delay_in_seconds"
        return 1
    }
    intervalInSeconds="$1";
    unixtime() {
        date +%s;
    }
    nextTimeLimit() {
        echo $(($(unixtime) + intervalInSeconds));
    }
    limit=$(nextTimeLimit);
    while read -r line; do
        if test "$limit" -lt "$(unixtime)"; then
            limit=$(nextTimeLimit);
            echo "$line";
        fi
    done;
}

# Consume stdin and spit it out at some rate-limited time interval.
# Uses bash SECONDS (man bash then /SECONDS) instead of date(1).
# The time unit is seconds -- not anything smaller (that I can find).
throttle() {
    local -i limit
    [[ -z $1 ]] && {
        echo >&2 "Usage: ${FUNCNAME[0]} delay_in_seconds"
        return 1
    }
    ((limit = SECONDS + $1))
    while read -r line; do
        if ((limit < SECONDS)); then
            ((limit = SECONDS + $1))
            echo "$line"
        fi
    done
}

# }}}

# ---------- path  {{{
# MacOS with 'brew install coreutils findutils':
for d in \
    /usr/local/opt/ruby/bin \
    /usr/local/opt/make/libexec/gnubin \
    /usr/local/opt/gnu-indent/libexec/gnubin \
    /usr/local/opt/gnu-tar/libexec/gnubin \
    /usr/local/opt/gnu-sed/libexec/gnubin \
    /usr/local/opt/grep/libexec/gnubin \
    /usr/local/opt/findutils/libexec/gnubin \
    /usr/local/opt/coreutils/libexec/gnubin \
; do
    [[ -d $d ]] && {
        path_prepend "$d"
        os_gnu=true
    }
done
unset d

path_prepend "${M2}"               # Maven
path_prepend "${HOME}/.cargo/bin"  # Rust / Cargo
path_prepend "${HOME}/scripts"
path_prepend "${HOME}/.local/bin"
path_prepend "${HOME}/bin"

path_append "/usr/local/sbin"
path_append "/usr/sbin"
path_append "/sbin"
path_append "/opt/bin"
path_append "${HOME}/scripts/games"
path_append "${HOME}/.krew/bin"

export PATH
# }}}

# ---------- evals {{{
[[ $os_gnu ]] && [[ -f ${HOME}/.dir_colors ]] && eval "$(dircolors -b "${HOME}/.dir_colors")"
[[ $os_mac ]] && export CLICOLOR=1

is_command keychain && eval "$(keychain --eval --ignore-missing --quiet id_rsa verizon_atlassian)"
if [[ -z $(pidof ssh-agent) ]]; then
    is_command ssh-agent && eval "$(ssh-agent -s)"
fi

# https://github.com/nvbn/thefuck
is_command thefuck && eval "$(thefuck --alias)"

# pipx for Python packages
is_command register-python-argcomplete && eval "$(register-python-argcomplete pipx)"

# TODO ugly, and pdftotext not invoked properly:
#is_command lesspipe && eval "$(SHELL=/bin/sh lesspipe)"
# }}}

# ---------- environment {{{1
## FIGNORE is a list of *suffixes*, not exact matches. So abc.git/ will be filtered out!
#FIGNORE=".git:.svn:CVS"

# Use 'export' for the case where you run 'bash --norc'
export HISTIGNORE="&:l:ll:ls:pwd:[bf]g:exit:clear:[ ]*"
export HISTSIZE=  # 1048576
# Change file location because certain bash sessions truncate .bash_history file upon close.
# http://superuser.com/questions/575479/bash-history-truncated-to-500-lines-on-each-login
export HISTFILE=~/.bash_eternal_history
unset HISTFILESIZE  #export HISTFILESIZE=524288000
export HISTTIMEFORMAT="[%F %T] "
# ----
## Undocumented feature which sets the size to "unlimited".
## https://stackoverflow.com/questions/9457233/unlimited-bash-history
#export HISTFILESIZE=
#export HISTSIZE=
#export HISTTIMEFORMAT="[%F %T] "
# ----
# Force prompt to write history after every command.
# http://superuser.com/questions/20900/bash-history-loss
# PROMPT_COMMAND="history -a; history -n; ${PROMPT_COMMAND}"
# PROMPT_COMMAND="${PROMPT_COMMAND:+${PROMPT_COMMAND} ;}history -a; history -c; history -r";
# Note: this will mingle histories from all shells currently open

export BROWSER="firefox '%s' &"
export CVS_RSH="$(which ssh)"
export EDITOR="$(which vim)"
export GREP_COLOR=32
export LESS="--ignore-case --RAW-CONTROL-CHARS --squeeze-blank-lines"
# shellcheck disable=SC2016  # we don't want to expand
export LESSOPEN='|$HOME/.lessfilter %s'

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

## /usr/bin/time format (pass '-v' for exhaustive output)
export TIME="--\\n%C  [exit %x]\\nreal %e\\tCPU: %P  \\t\\tswitches: %c forced, %w waits\\nuser %U\\tMem: %M kB maxrss\\tpage faults: %F major, %R minor\\nsys  %S\\tI/O: %I/%O"

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

# TODO clang/llvm on MacOS
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
# SC2002: Ignore Useless Use Of Cat
# SC2164: Ignore "'cd ... || return' in case cd fails"
export SHELLCHECK_OPTS='--shell=bash --exclude=SC2002 --exclude=SC2164'

# Tell xmllint to find asciidoc's catalog files
f="/usr/local/etc/xml/catalog"
[[ -f "$f" ]] && export XML_CATALOG_FILES="$f"

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
[[ $os_mac ]] && is_command "ggrep" && grep="ggrep --color=auto" || grep="\\grep --color=auto"
alias grep="$grep --color=auto --exclude={tags,cscope.out} --binary-files=without-match --exclude-dir={CVS,.bzr,.git,.hg,.svn,_darcs}"
alias grepbash="$grep -R --exclude=* --include=*.{bash,sh}"
alias grepcode="$grep -R --exclude=* --include=*.{c,C,cc,CC,cpp,go,h,H,hs,java,pl,properties,py,rb,s,S,scala,sh}"
alias grepdoc="$grep -R --exclude=* --include=*.{adoc,asciidoc,bib,howto,info,markdown,md,text,txt,htm,html,rst,tex,todo,wip}"
alias grepbuild="$grep -R --exclude=* --include=*.{ac,am,in,m4,mk,properties,sh,xml} --include={*akefile,*configure*,GNUmake*}"
alias grepwhite="$grep --binary-files=without-match '[[:space:]]\\+$' -R"
alias g=grepcode
unset grep

function grepport() {
    [[ $1 =~ ^[0-9]+$ ]] || {
        echo "$1 is not a valid port number"
        return 1
    }
    lsof -n -iTCP:"$1"
}

[[ $os_mac ]] && {
    alias route="netstat -nr"
}

## GNU xargs supports --no-run-if-empty
[[ $os_mac ]] && [[ $os_gnu ]] && {
    is_command gsed && alias sed=gsed
    is_command gxargs && alias xargs=gxargs
}

## propagate (sub-)command completion when using sudo
alias sudo='sudo '

## default options to common commands
alias rm="rm -i --one-file-system"
[[ $os_mac ]] && alias pstree="pstree -w -g3"
if [[ $os_mac ]]; then
    alias tree="tree --dirsfirst -C"
else
    alias tree="tree --dirsfirst"
fi
alias vi="vim"
[[ $os_mac ]] && {
    alias vi="mvim -v"
    alias vim="mvim"
}

if is_command exa; then
    alias exa="exa -Fa --group-directories-first -gm --git --time-style=long-iso"
fi

# Inhibit "non-prefixed coreutils" warning from `brew doctor`
[[ $os_mac ]] && {
    alias brew="PATH=/usr/local/bin:/usr/bin:/bin:/usr/local/sbin:/usr/sbin:/sbin /usr/local/bin/brew"
}

# GNU parallel
#is_command parallel && alias parallel="parallel --will-cite"

[[ -x /usr/bin/time ]] && alias time="/usr/bin/time"
[[ -x /usr/local/bin/time ]] && alias time="/usr/local/bin/time"
[[ $os_mac ]] && [[ $os_gnu ]] && is_command gtime && alias time=gtime
[[ -x /sbin/ifconfig ]] && alias ifconfig="/sbin/ifconfig"
[[ -x /usr/libexec/locate.updatedb ]] && alias updatedb="sudo /usr/libexec/locate.updatedb"
is_command glances && alias top=glances

## new commands
alias dvdplay="mplayer -nocache dvdnav://"
alias emptytrash="rm -rf ~/.local/share/Trash/*; rm -rf ~/.Trash/*"
alias loffice="libreoffice"
alias manga="thunar &>/dev/null &"
alias path='echo -e ${PATH//:/\\n}'
alias quickweb='python2 -m SimpleHTTPServer'
alias qweb='python3 -m http.server'
#alias suspend="pm-suspend"  # suspend is a bash builtin
is_command ncdu && alias cdu="ncdu --color dark -rr --exclude .git"
is_command tokei && alias sloc="tokei" #\$(find . -type f)"
is_command tokei && alias sloc-all="tokei --hidden --no-ignore --no-ignore-parent --no-ignore-vcs"
is_command tokei && alias sloc-details="tokei --hidden --no-ignore --no-ignore-parent --no-ignore-vcs -f"

[[ $os_linux ]] && {
    alias ipa="ip -brief -color address"
    alias ipl="ip -brief -color link"
    # on older versions of ip(8):  "ip -oneline"
}

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

## locale issues
is_command calibre && alias calibre="LC_ALL=en_US calibre"
#alias git="LC_ALL=fr_FR@euro git"
is_command glade-3 && alias glade="LC_ALL=en_US glade-3"
is_command wicd-curses && alias wicd-curses="LC_ALL=C wicd-curses"
## TERM issues
is_command urxvt && {
    alias rxvt="urxvt"
    alias rxvt-unicode="urxvt"
}

## colors
is_command grc && {
    alias cvs="grc cvs"
    alias netstat="grc netstat"
    alias ping="grc ping"
    alias svn="grc svn"
    alias traceroute="grc traceroute"
}

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
    # from package lesspipe: color doesn't work for me following man page
    #alias ccat='lesspipe.sh'
else
    alias ccat='cat'
fi

# TODO try out 'mdv' to view Markdown

## diff
is_command colordiff && diffprog="colordiff" || diffprog="diff"
alias diff="$diffprog -NrbB -x .git"
unset diffprog
# poor person's colordiff. doesn't play nice with diff-so-fancy.
function diff1() {
    local regex
    # damn it
    regex='s/^-/\x1b[1;31m-/;s/^+/\x1b[1;32m+/;s/^@/\x1b[1;34m@/;s/^Only in/\x1b[1;36mOnly in/;s/^diff /\x1b[1;36mdiff /;s/$/\x1b[0m/'
    command diff -U1 --minimal "$@" |
    sed "$regex"
}
# not good, diff1 is better?
function diff2() { command diff -U3 --minimal "$@" | diff-so-fancy; }

# not good
#regex='s/^--- /\x1b[0;31m--- /;s/^\+\+\+ /\x1b[0;32m\+\+\+ /;s/^-/\x1b[1;31m-/;s/^+/\x1b[1;32m+/;s/^@/\x1b[1;34m@/;s/^Only in/\x1b[1;36mOnly in/;s/^diff /\x1b[1;36mdiff /;s/$/\x1b[0m/'

# ok-ish with diff-highlight, breaks diff-so-fancy.
# command colordiff -U2 --minimal logs.ori/ logs/ | sed 's/^-/\x1b[1;31m-/;s/^+/\x1b[1;32m+/;s/^@/\x1b[1;34m@/;s/$/\x1b[0m/' | diff-highlight

## KDE display settings (2nd monitor...)
is_command kcmshell4 && {
    alias kdisplay="kcmshell4 display"
    alias xdisplay="kcmshell4 display"
}

## fuzzy-finder
is_command fzf && {
    # ctr-o opens the file in vim
    export FZF_DEFAULT_OPTS="--bind='ctrl-o:execute(vim {})+abort'"
    # 'preview' alias auto-opens a preview on the right pane
    if is_command bat; then
        alias preview="fzf --preview 'bat --color always {}'"
    else
        alias preview="fzf --preview 'cat {}'"
    fi
    #alias o="fzf --preview 'bat --color always {}' | xargs -i '{}' xdg-open '{}'"
    #[[ $os_mac ]] && alias xdg-open=open # does it work?
}

[[ -f /Applications/Meld.app/Contents/MacOS/Meld ]] && alias meld=/Applications/Meld.app/Contents/MacOS/Meld

# }}}

# ---------- shopts {{{
shopt -s checkwinsize
shopt -s dotglob
shopt -s extglob
shopt -s histappend
shopt -s no_empty_cmd_completion
# shellcheck disable=SC2071  # This is indeed a string comparison
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
export c_white='\033[0;37m'
export c_bold_black='\033[1;30m'
export c_bold_red='\033[1;31m'
export c_bold_green='\033[1;32m'
export c_bold_yellow='\033[1;33m'
export c_bold_blue='\033[1;34m'
export c_bold_purple='\033[1;35m'
export c_bold_cyan='\033[1;36m'
export c_bold_white='\033[1;37m'
export c_none='\033[00m'

# Codes:
#  \033[<Select Graphic Rendition>;<Color>m
# You can combine SGRs as semicolon-separated.
#   Example:  bold italic, default color   \033[1;3;m
# SGRs are:
# 0  normal
# 1  bold
# 2  faint      (de-bold)
# 3  italic
# 4  underline
# 5  slow blink (limited support. Terminal.app:yes iTerm:no)
# 7  reverse    (swap fg/bg)

function test_colors() {
    {
  echo -e "${c_none}nocolor"
  echo -e -n "${c_black}black $c_red red $c_green green $c_yellow yellow"
  echo -e "$c_blue blue $c_purple purple $c_cyan cyan $c_white white"
  echo -e -n "${c_bold_black}blackB $c_bold_red redB $c_bold_green greenB $c_bold_yellow yellowB"
  echo -e "$c_bold_blue blueB $c_bold_purple purpleB $c_bold_cyan cyanB $c_bold_white whiteB"
    } | column -t
}
# }}}

# ---------- prompts {{{
## PROMPT_COMMAND : window title for X terminals
##            PS1 : shell prompt
if [[ $EUID == 0 ]] ; then
    c1="\\[${c_red}\\]"   # colors in PS1 must be surrounded by escaped brackets
    c2="\\[${c_bold_red}\\]"
    id='\h'               # identifier part
    pr='#'                # prompt symbol
else
    c1="\\[${c_blue}\\]"
    c2="\\[${c_bold_green}\\]"
    id='\u@\h'            # identifier part
    pr='$'                # prompt symbol
fi
c3="\\[${c_bold_blue}\\]"
c4="\\[${c_bold_black}\\]"
cx="\\[${c_none}\\]"

## Mix double quotes (for variables, must be expanded now)
## and single quotes (for subshells, must not be expanded until prompt is evaluated)
[[ $os_linux ]] && pre_ps1="${c1}\\D{%m-%d %R} ${c2}${id} "
[[ $os_mac ]]   && pre_ps1="${c2}\\u "

# shellcheck disable=SC2016
post_ps1="${c3}["'$(echo $(ls -1 | wc -l))'"] \\W${c4}"'$(type -t __git_ps1 &>/dev/null && __git_ps1)'" ${c3}$pr $cx"

PS1="${pre_ps1}${post_ps1}"

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
unset c1 c2 c3 c4 cx id pr
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
    ${HOME}/.config/broot/launcher/bash/br \
; do
    # shellcheck source=/dev/null  # Don't shellcheck those files
    [[ -f $f ]] && source "$f"
done
[[ $os_mac ]] && is_command brew && {
    ## Note: brew's bash_completion makes bash start very slow
    #f="$(brew --prefix)/etc/bash_completion"
    ## shellcheck source=/dev/null
    #[[ -f $f ]] && source "$f"
    # shellcheck disable=SC2071  # This is indeed a string comparison
    [[ $BASH_VERSION > 4 ]] && {
        export BASH_COMPLETION_COMPAT_DIR="$(brew --prefix)/etc/bash_completion.d"
        # Tip: replace function _have() with 'true'. Will load more things, but faster.
        for f in \
            "$(brew --prefix)/share/bash-completion/bash_completion" \
            "$(brew --prefix)/etc/profile.d/bash_completion.sh" \
        ; do
            # shellcheck source=/dev/null
            [[ -f $f ]] && source "$f"
        done
    }
    brew-upgrade() {
        brew update
        brew upgrade
        brew cask upgrade --greedy
    }
}
#
# Skip the fzf bash completions; they break ssh and scp completion for host names!
# ${XDG_CONFIG_HOME:-$HOME/.config}/fzf/fzf.bash \
# }}}

unset f d

## end profile
#set +x
#exec 2>&3 3>&-
##

# generated by workbrew
export HOMEBREW_INSTALL_BADGE="☕️"
export CONTACT=yvan.royon@verizon.com
is_command direnv && eval "$(direnv hook bash)"
