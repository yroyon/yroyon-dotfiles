#!/usr/bin/env bash
# Install dotfiles, by creating symlinks

# ---------- detect OS {{{
name=$(uname -s)
if [[ $name == Darwin ]]; then
    os_mac=true
    # detect os_gnu later, in the 'path' section of this file
elif [[ $name =~ Linux ]]; then
    os_linux=true
elif [[ $name =~ MINGW32_NT ]]; then
    # shellcheck disable=SC2034  # unused
    os_windows=true
fi
unset name
# }}}

# Location of this script.
# We use it to find the different subdirs even after we move around.
here="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# MacOS doesn't have XDG_CONFIG_HOME set by default
XDG_CONFIG_HOME=${XDG_CONFIG_HOME-$HOME/.config}

# Polite software that uses XDG_CONFIG_HOME
pushd "$XDG_CONFIG_HOME"
for entry in "${here}"/xdg_config_home/*; do
    ln -snf "${entry}" .
done
popd

# Impolite software that store config in the HOME directory.
# In the git repo, we skip the initial dot in the filenames.
# So, when creating the symlinks in $HOME, let's add the dots back.
pushd "${HOME}"
files=("${here}"/home/*)
[[ $os_mac ]] && files+=("${here}"/home_mac/*)
[[ $os_linux ]] && files+=("${here}"/home_linux/*)

for entry in "${files[@]}"; do
    ln -snf "${entry}" ".$(basename "$entry")"
done
popd

