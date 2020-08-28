#!/usr/bin/env bash
# -> use 3rd party package 'topgrade' instead

# OS: MacOS Homebrew
brew-upgrade() {
    brew update
    brew upgrade
    brew cask upgrade --greedy
}

# OS: Debian/Ubuntu
apt-upgrade() {
    sudo apt update
    sudo apt upgrade
}

# Lang: Rust
cargo-upgrade() {
    cargo install cargo-update
    cargo install-update --all
}

# Lang: Python2
pip2-upgrade() {
    pip2 freeze --local | grep -v '^\-e' | cut -d = -f 1 | xargs -n1 pip2 install -U
}

# Lang: Python3
pip3-upgrade() {
    pip3 freeze --local | grep -v '^\-e' | cut -d = -f 1 | xargs -n1 pip3 install -U
}

