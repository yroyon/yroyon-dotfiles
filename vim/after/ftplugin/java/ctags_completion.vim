"" You need to run scripts/javatags.sh
"" Basically this:
" [ x"${JAVA_HOME}" != x ] || die "variable ${JAVA_HOME} is not set"
" cd "${JAVA_HOME}" || die  "$JAVA_HOME is not valid"
" [ -f src.zip ] || die "can't find $JAVA_HOME/src.zip"
" [ -d src ] && sudo rm -rf src/
" sudo mkdir src && sudo chmod go+w src/ && cd src/ && unzip ../src.zip || die "problem unzipping src.zip"
" ctags -R --language-force=java -f ~/.vim/tags/java.ctags "${JAVA_HOME}/src/"

" use the JDK tags.
setlocal tags+=$HOME/.vim/tags/java.ctags

" completion: first Java keywords, then JDK source, then project source.
setlocal cpt=k,.,w,b,u,t,i

" ~/scripts/vimant.sh
" -------------------
" #!/bin/sh
" /usr/local/bin/ant -Dbuild.compiler.emacs=true -quiet -find build.xml
" ${*:-classes} 2>&1 | grep '\[javac\]'
"
"set efm=\ %#[javac]\ %#%f:%l:%c:%*\\d:%*\\d:\ %t%[%^:]%#:%m,
"\%A\ %#[javac]\ %f:%l:\ %m,%-Z\ %#[javac]\ %p^,%-C%.%#
"
" (something missing, he's not calling vimAnt in efm... maybe this errorformat
" is equivalent to build.compiler.emacs)

