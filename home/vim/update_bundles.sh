#!/usr/bin/env bash

here="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
pushd "$here" &> /dev/null

## Initial setup, do this manually for a new git clone / new machine:
#git submodule init
#git submodule update

## pull method, I found it unreliable (conflicts):
#git submodule foreach git checkout master
#git submodule foreach git pull

## rebase method, preferred:
git submodule foreach 'git fetch || :'
git submodule foreach 'git checkout master || :'
git submodule foreach 'git rebase || :'

## The CoC plugin needs a heavyweight update mechanism:
[[ -d bundle/coc/ ]] && {
    pushd bundle/coc/ &> /dev/null
    yarn install --frozen-lockfile
    # yarn upgrade-interactive --latest
    # yarn upgrade
    popd &> /dev/null
}
