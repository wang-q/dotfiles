#!/usr/bin/env bash

# check gnu stow is installed
hash stow 2>/dev/null || {
    echo >&2 "GNU stow is required but it's not installed.";
    echo >&2 "Install with homebrew: brew install stow";
    exit 1;
}

BASE_DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
cd ${BASE_DIR}

DIRS=( stow-ack stow-bash stow-git stow-perltidy stow-screen stow-wget stow-vim stow-vimperator )

echo "==> Restow dotfiles <=="
for d in ${DIRS[@]}
do
    echo "==> ${d}"
	stow -t ${HOME} ${d} -v 2
done
