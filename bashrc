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

dirsize() {
    find ${1-.} -maxdepth 1 -type d -exec du -hs '{}' \;
}

lsize() {
    du -b --max-depth 1 ${1} | sort -nr | perl -pe \
        's{([0-9]+)}{sprintf "%.1f%s", $1>=2**30? ($1/2**30, "G"): $1>=2**20? ($1/2**20, "M"): $1>=2**10? ($1/2**10, "K"): ($1, "")}e'
}

## default options to common commands
alias diff="colordiff -NrbB"
alias grep="/bin/grep --color"
alias rm="rm -i"
alias boswars="boswars -W"
alias tree="/usr/bin/tree --dirsfirst"

## locale issues
alias git="LC_ALL=fr_FR@euro git"
alias glade="LC_ALL=en_US glade-3"
alias calibre="LC_ALL=en_US calibre"

## colours
alias cvs="grc cvs"
alias netstat="grc netstat"
alias ping="grc ping"
alias svn="grc svn"
alias traceroute="grc traceroute"

## new commands
alias dvdplay="mplayer -nocache dvdnav://"
alias emptytrash="rm -rf ~/.local/share/Trash/*"
alias g="grepcode"
alias loffice="libreoffice"
alias manga="thunar &>/dev/null &"
alias path='echo -e ${PATH//:/\\n}'
alias quickweb='python -c "import SimpleHTTPServer;SimpleHTTPServer.test()"'
## for some TERM issues
alias rxvt="urxvt"
alias rxvt-unicode="urxvt"

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
export HISTIGNORE="&:l:ll:ls:pwd:[bf]g:exit:clear:[ ]*"
export HISTSIZE=4096
export HISTFILESIZE=2097152
export LESS="$LESS --ignore-case"
export PATH+=":${HOME}/scripts"
[ -d "${HOME}"/scripts/games ] && export PATH+=":${HOME}/scripts/games"

export JAVA_HOME=/opt/sun-jdk
export JAVAC="${JAVA_HOME}"/bin/javac

## VMware segfaults @work without this:
export VMWARE_USE_SHIPPED_GTK=force

## For JOGL (it seems the default is missing .so)
export EGL_DRIVER=/usr/lib/egl/egl_glx.so

## ooffice is veeery slow to start if the print server is unreachable
##   (ServerName in /etc/cups/client.conf).
## => set to any non-empty value:
export SAL_DISABLE_SYNCHRONOUS_PRINTER_DETECTION="a"

## Home'Bank setup
[ -d /opt/HomeBank ] && {
    export HB_HOME=/opt/HomeBank
    export PATH+=":${HB_HOME}"
}

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


# TODO from ciaranm
mktar() {
    tar jcvf "${1%%/}.tar.bz2" "${1%%/}/"
}

ps_scm_f() {
    local s=
    if [[ -d ".svn" ]] ; then
        local r=$(svn info | sed -n -e '/^Revision: \([0-9]*\).*$/s//\1/p' )
        s="(r$r$(svn status | grep -q -v '^?' && echo -n "*" ))"
    else
        local d=$(git rev-parse --git-dir 2>/dev/null) b= r= a= c= e= f= g=
        if [[ -n "${d}" ]] ; then
            if [[ -d "${d}/../.dotest" ]] ; then
                if [[ -f "${d}/../.dotest/rebase" ]] ; then
                    r="rebase"
                elif [[ -f "${d}/../.dotest/applying" ]] ; then
                    r="am"
                else
                    r="???"
                fi
                b=$(git symbolic-ref HEAD 2>/dev/null )
            elif [[ -f "${d}/.dotest-merge/interactive" ]] ; then
                r="rebase-i"
                b=$(<${d}/.dotest-merge/head-name)
            elif [[ -d "${d}/../.dotest-merge" ]] ; then
                r="rebase-m"
                b=$(<${d}/.dotest-merge/head-name)
            elif [[ -f "${d}/MERGE_HEAD" ]] ; then
                r="merge"
                b=$(git symbolic-ref HEAD 2>/dev/null )
            elif [[ -f "${d}/BISECT_LOG" ]] ; then
                r="bisect"
                b=$(git symbolic-ref HEAD 2>/dev/null )"???"
            else
                r=""
                b=$(git symbolic-ref HEAD 2>/dev/null )
            fi

            if git status | grep -q '^# Changes not staged' ; then
                a="${a}*"
            fi

            if git status | grep -q '^# Changes to be committed:' ; then
                a="${a}+"
            fi

            if git status | grep -q '^# Untracked files:' ; then
                a="${a}?"
            fi

            e=$(git status | sed -n -e '/^# Your branch is /s/^.*\(ahead\|behind\).* by \(.*\) commit.*/\1 \2/p' )
            if [[ -n ${e} ]] ; then
                f=${e#* }
                g=${e% *}
                if [[ ${g} == "ahead" ]] ; then
                    e="+${f}"
                else
                    e="-${f}"
                fi
            else
                e=
            fi

            b=${b#refs/heads/}
            b=${b// }
            [[ -n "${b}" ]] && c="$(git config "branch.${b}.remote" 2>/dev/null )"
            [[ -n "${r}${b}${c}${a}" ]] && s="(${r:+${r}:}${b}${c:+@${c}}${e}${a:+ ${a}})"
        fi
    fi
    s="${s}${ACTIVE_COMPILER}"
    s="${s:+${s} }"
    echo -n "$s"
}


[ -f /etc/profile.d/bash-completion ]     && source /etc/profile.d/bash-completion
[ -f /etc/profile.d/bash-completion.sh ]  && source /etc/profile.d/bash-completion.sh
[ -f /usr/share/compleat/compleat_setup ] && source /usr/share/compleat/compleat_setup
[ -f /usr/bin/ssh-askpass-fullscreen ]    && export SUDO_ASKPASS=/usr/bin/ssh-askpass-fullscreen

