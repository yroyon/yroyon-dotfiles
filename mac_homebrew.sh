#!/bin/bash

set -o nounset
set -o errexit
#set -o pipefail

# Install Xcode Command-Line Tools
if ! xcode-select -p &>/dev/null; then
    xcode-select --install
    exit 0
fi

# Install homebrew
which brew &>/dev/null || /usr/bin/ruby -e \
    "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

# it spies on us by default
brew analytics off

brew update
brew upgrade

### Need --with-default-names
gnu=(
findutils
gnu-indent
gnu-sed
gnu-tar
gnu-time
gnu-which
grep
make
)

#brew uninstall "${gnu[@]}"
brew install "${gnu[@]}" # --with-default-names

# NOTE: had permission issues with:
# brew reinstall findutils gnu-sed gnu-tar grep --with-default-names
#
# Had to run with sudo.
# 1. vi /usr/local/Homebrew/Library/Homebrew/brew.sh
#    Change check-run-command-as-root() to always succeed
# 2. sudo brew reinstall ...
# 3. Fix permissions.
#    find /usr/local -user root; find ~ -user root
#    sudo chown -R royonyv /Users/royonyv/Library/Logs/Homebrew/ /usr/local/{bin,etc,opt,share/info,share/man,var/homebrew,Cellar,Caskroom,Homebrew}
# 4. Revert /usr/local/Homebrew/Library/Homebrew/brew.sh

taps=(
caskroom/cask
caskroom/fonts
homebrew/bundle
homebrew/core
homebrew/services
)
#brew tap "${taps[@]}"

### Basic essentials
pkg_needed=(
bash
bash-completion@2
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
)

### Languages, runtimes, dev tools
pkg_devel=(
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
parallel
pcre
pkg-config
qcachegrind
ruby
rust
shellcheck
sloccount
socat
subversion
tmux
valgrind
watchman
xdot
zzuf
)

### VM & container related
pkg_virt=(
corectl
fleetctl
xhyve
)

### Nice-to-have tools
pkg_tools=(
asciidoc
ccat
ghostscript
gnuplot
htop
sshfs
imagemagick
jpeg
less
lesspipe
libmagic
netperf
odt2txt
python
sysbench
the_silver_searcher
vimpager
watch
xz
)

brew install "${pkg_needed[@]}" "${pkg_devel[@]}" "${pkg_virt[@]}" "${pkg_tools[@]}"

### With options
#brew install moreutils --without-parallel

### Completions
completions=(
brew-cask-completion
gem-completion
launchctl-completion
maven-completion
open-completion
pip-completion
rustc-completion
sonar-completion
vagrant-completion
)
brew install "${completions[@]}"

### Packages that come in separate "casks"
casks=(
corectl-app
docker
firefox
gitx
hipchat
iterm2
keepassx
osxfuse
slack
spectacle
visualvm
wireshark
xquartz
)
# continue on errors (like a pre-existing /Applications/*.app)
# or better, just force it. override the existing install.
# this should not delete existing preferences/profiles, unlike uninstall --force.
# tested on slack: it logged me out (forgot login/pass), but kept my color theme. color theme may have been saved on slack servers.
# :-(
# tested on firefox: kept my profile.
brew cask install --force "${casks[@]}" || true

### Python3 modules and tools
pystuff=(
ptpython
radon
flake8
)
# pip3 was installed as part of python3 above
pip3 install "${pystuff[@]}"

### Ruby tools
rubystuff=(
asciidoctor
)
# gem comes with the pre-installed ruby
# XXX needs sudo access
sudo gem install "${rubystuff[@]}"

brew linkapps  # deprecated
brew cleanup
brew cask cleanup  # any reason 'brew cleanup' doesn't do this?
brew doctor || true

RED='\033[0;31m'
NC='\033[0m'

echo
echo -e "Remember to have these settings in ${RED}${HOME}/.bashrc${NC}"
echo
echo 'PATH=/usr/local/opt/coreutils/libexec/gnubin:/usr/local/bin:$PATH'
echo 'f="$(brew --prefix)/share/bash-completion/bash_completion"'
echo '[[ -f $f ]] && source "$f"'

# ---------- END ---------- #

### TODO

pkg_todo=(
shellinabox
stunnel
userspace-rcu
xmlto
languagetool
)
#brew install "${pkg_todo[@]}"

casks_todo=(
java
slate
shady
)
### Other casks:
# . seil: remap Caps Lock key. I use System Prefs->Keyboard->Modifier Keys
#         I think I used Caps Lock as Mega Combo key, for ???
# . karabiner: remap more keys. Forgot what for. Maybe Cmd-K for iTerm.
# . bettertouchtool: more trigger actions. Not free.
# . go2shell: open term 'here' in Finder. Broken.
#brew cask install "${casks_todo[@]}"

### Stuff I've installed, but I need to test before I decide to keep
is_it_good=(
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
)
#brew install "${is_it_good[@]}"

# Bash-completion for rustup
#type -p rustup &>/dev/null && {
#    rustup completions bash | sudo tee /usr/local/share/bash-completion/completions/rustup
#}

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

