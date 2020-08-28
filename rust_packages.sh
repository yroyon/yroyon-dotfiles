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
procs
)
# kmon

misc=(
hexyl
hyperfine
loc
tokei
)

rustup update

cargo install "${cli[@]}" "${tui[@]}" "${misc[@]}"
cargo install cargo-update
cargo install-update --all

