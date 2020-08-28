#!/bin/sh

set -euo pipefail
#set -x

example=$(mktemp).cpp
trap "rm -f $example" EXIT

for file in colors/*.vim bundle/colorscheme-*/**/*.vim; do
    scheme=$(basename "${file%.vim}")
  cat > $example <<EOF
// Colorscheme "$scheme".
// To stop iteration, add ABORT anywhere below and save file.

#include <stdio.h>

namespace XYZ {

static int x = 1;

struct A {
  int x;
  int y;
  void a() const { return x + y; }
};

int main() {
  A var;
  printf("Hello world!\n");
  return 0;
}

}  // XYZ
EOF
  gvim --nofork +':syntax on' +":set runtimepath+=$PWD" +":colo $scheme" $example
  if [ $(grep ABORT $example | grep -v 'add ABORT anywhere' | wc -l) -gt 0 ]; then
    echo 'Aborting per user request...'
    break
  fi
done

