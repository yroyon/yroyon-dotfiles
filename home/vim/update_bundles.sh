#!/bin/sh
#git submodule init
#git submodule update
#git submodule foreach git checkout master
#git submodule foreach git pull
git submodule foreach git fetch
git submodule foreach git rebase

pushd bundle/coc/
yarn install --frozen-lockfile
popd
