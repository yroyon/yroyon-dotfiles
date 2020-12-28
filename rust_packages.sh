#!/usr/bin/env bash

cli=(
bat
exa
fd-find
mdcat
ripgrep
)
# antr funzzy watchexec

tui=(
bandwhich
broot
gping
procs
)
# kmon

misc=(
git-delta
hexyl
hyperfine
loc
tokei
)

rustup update

cargo install "${cli[@]}" "${tui[@]}" "${misc[@]}"
cargo install cargo-update
cargo install-update --all

