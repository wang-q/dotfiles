#!/usr/bin/env bash

# chech faops is installed
hash stow 2>/dev/null || {
    echo >&2 "GNU stow is required but it's not installed.";
    echo >&2 "Install with homebrew: brew install stow";
    exit 1;
}

BASE_DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
cd ${BASE_DIR}

DIRS=( bash git screen vim vimperator wget perltidy )

echo "==> Restow dotfiles <=="
for d in ${DIRS[@]}
do
    echo "==> ${d}"
	stow -t ${HOME} ${d} -v 2
done
