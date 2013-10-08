" Quickfix (:make and :cn).
"compiler ant
"setlocal makeprg=sbt\ compile
"setlocal efm=%A\ %#[javac]\ %f:%l:\ %m,%-Z\ %#[javac]\ %p^,%-C%.%#

