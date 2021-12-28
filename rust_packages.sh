#!/usr/bin/env bash

cli=(
bat
dua-cli
exa
fd-find
mdcat
ripgrep
)
# ht -> curl replacement

tui=(
)
# bandwhich
# broot
# gping
# procs

misc=(
git-delta
hexyl
hyperfine
jsonschema
loc
tokei
)
# watchexec -> notify wrapper

# If not on crates.io...
additional_repos=(
)
# https://github.com/jez/as-tree

rustup update

for repo in "${additional_repos[@]}"; do
    cargo install --force --git "$repo"
done
cargo install "${cli[@]}" "${tui[@]}" "${misc[@]}"
cargo install cargo-update
cargo install-update --all

