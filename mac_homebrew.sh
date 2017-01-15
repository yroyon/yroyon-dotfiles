#!/bin/bash

# Install Xcode Command-Line Tools
if ! xcode-select -p ; then
    xcode-select --install
    exit 0
fi

# Install homebrew
which brew || /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

brew update
brew upgrade

### Need --with-default-names
gnu="
findutils
gnu-indent
gnu-sed
gnu-tar
gnu-time
gnu-which
grep
"
brew tap homebrew/dupes  # for GNU grep
#brew uninstall $gnu
brew install $gnu --with-default-names

### Basic essentials
pkg_needed="
bash
bash-completion
binutils
coreutils
curl
gawk
git
git-extras
keychain
macvim
pidof
pstree
python3
rename
tree
wget
"

### Languages, runtimes, dev tools
pkg_devel="
afl-fuzz
ant
automake
bazaar
cabal-install
cfr-decompiler
cgdb
clang-format
cloc
cmake
colordiff
cppcheck
cscope
ctags
doxygen
flawfinder
fswatch
gcc
gdb
ghc
global
go
golo
gprof2dot
haskell-stack
iperf
ipmitool
jq
jshon
lcov
llvm
lmdb
maven
mercurial
node
pcre
pkg-config
qcachegrind
rust
sbt
scala
scalariform
shellcheck
sloccount
socat
sparse
subversion
tmux
valgrind
watchman
xdot
zzuf
"

### VM & container related
pkg_virt="
corectl
fleetctl
xhyve
"

### Nice-to-have tools
pkg_tools="
asciidoc
ghostscript
gnuplot
homebrew/fuse/sshfs
imagemagick
jpeg
less
lesspipe
libmagic
netperf
odt2txt
openssl
python
readline
sysbench
the_silver_searcher
thefuck
watch
xz
"

brew install $pkg_needed $pkg_devel $pkg_virt $pkg_tools

### Packages that come in separate "casks"
casks="
firefox
gitx
iterm2
osxfuse
spectacle
visualvm
wireshark
"
brew cask install $casks

### Python3 modules and tools
pystuff="
ptpython
radon
flake8
"
pip3 install $pystuff

### Ruby tools
rubystuff="
asciidoctor
"
sudo gem install $rubystuff

brew linkapps
brew cleanup
brew doctor

### TODO

pkg_todo="
shellinabox
stunnel
userspace-rcu
xmlto
languagetool
"
#brew install $pkg_todo

casks_todo="
docker
java
slate
shady
"
### Other casks:
# . seil: remap Caps Lock key. I use System Prefs->Keyboard->Modifier Keys
#         I think I used Caps Lock as Mega Combo key, for ???
# . karabiner: remap more keys. Forgot what for. Maybe Cmd-K for iTerm.
# . bettertouchtool: more trigger actions. Not free.
# . go2shell: open term 'here' in Finder. Broken.
#brew cask install $casks_todo

### Stuff I've installed, but I need to test before I decide to keep
is_it_good="
ceylon
codeclimate
cowsay
ecj
etcd
findbugs
gcviewer
generate-json-schema
gnu-complexity
graphviz
fzf
harfbuzz
htop
ipfs
jansson
libevent
libpng
proguard
lua
resty
rpm
rpm2cpio
shared-mime-info
sonarqube
gnu-getopt
guile
gx
gx-go
"
#brew install $is_it_good

# Bash-completion for rustup
type -p rustup &>/dev/null && {
    rustup completions bash | sudo tee /usr/local/share/bash-completion/completions/rustup
}

# TODO fonts
#brew tap caskroom/fonts
#brew cask search /powerline/
# install those
#brew cask install font-meslo-lg-for-powerline

## Migration
# List your installed stuff:
#    brew bundle dump
# Creates a file 'Brewfile'. Copy it over to new machine. Then:
#    brew bundle

# TODO: I should commit my Brewfile instead of this script
#       Only add python/ruby stuff in an extra script

# For startup scripts (integration with launchd):
#    brew services
#    brew services list

