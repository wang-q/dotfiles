#!/usr/bin/env bash

# check gnu stow is installed
hash stow 2>/dev/null || {
    echo >&2 "GNU stow is required but it's not installed.";
    echo >&2 "Install with homebrew: brew install stow";
    exit 1;
}

# colors in term
# http://stackoverflow.com/questions/5947742/how-to-change-the-output-color-of-echo-in-linux
GREEN=
RED=
NC=
if tty -s < /dev/fd/1 2> /dev/null; then
  GREEN='\033[0;32m'
  RED='\033[0;31m'
  NC='\033[0m' # No Color
fi

log_warn () {
  echo -e "==> ${RED}$@${NC} <=="
}

log_info () {
  echo -e "==> ${GREEN}$@${NC}"
}

log_debug () {
  echo -e "==> $@"
}

# enter BASE_DIR
BASE_DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
cd "${BASE_DIR}" || exit

# stow configurations
mkdir -p ~/.config

log_warn "Restow dotfiles"
DIRS=( stow-git stow-htop stow-latexmk stow-perltidy stow-screen stow-wget stow-vim stow-proxychains )

for d in ${DIRS[@]}; do
    log_info "${d}"
    for f in $(find ${d} -maxdepth 1 | cut -sd / -f 2- | grep .); do
        homef="${HOME}/${f}"
        if [ -h "${homef}" ] ; then
            log_debug "Symlink exists: [${homef}]"
        elif [ -f "${homef}" ] ; then
            log_debug "Delete file: [${homef}]"
            rm "${homef}"
        elif [ -d "${homef}" ] ; then
            log_debug "Delete dir: [${homef}]"
            rm -fr "${homef}"
        fi
    done
	stow -t "${HOME}" "${d}" -v 2
done

# don't ruin Ubuntu
log_info "stwo-bash"
stow -t "${HOME}" stow-bash -v 2

# don't ruin Ubuntu
log_info "stow-htop2 to .config"
stow -t "${HOME}"/.config/htop stow-htop2 -v 2
