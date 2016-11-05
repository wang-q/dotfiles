#!/usr/bin/env bash

# check gnu stow is installed
hash stow 2>/dev/null || {
    echo >&2 "GNU stow is required but it's not installed.";
    echo >&2 "Install with homebrew: brew install stow";
    exit 1;
}

# colors in term
# http://stackoverflow.com/questions/5947742/how-to-change-the-output-color-of-echo-in-linux
GREEN='\033[0;32m'
NC='\033[0m' # No Color

BASE_DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
cd ${BASE_DIR}

DIRS=( stow-ack stow-bash stow-git stow-perltidy stow-screen stow-wget stow-vim stow-vimperator stow-proxychains )

echo -e "${GREEN}==> Restow dotfiles <==${NC}"
for d in ${DIRS[@]}
do
    echo -e "${GREEN}==> ${d}${NC}"
    for f in $(find ${d} -maxdepth 1 | cut -sd / -f 2- | grep .)
    do
        homef="${HOME}/${f}"
        if [ -h ${homef} ] ; then
            echo "==> Symlink exists: [${homef}]"
        elif [ -f ${homef} ] ; then
            echo "==> Delete file: [${homef}]"
            rm ${homef}
        elif [ -d ${homef} ] ; then
            echo "==> Delete dir: [${homef}]"
            rm -fr ${homef}
        fi
    done
	stow -t ${HOME} ${d} -v 2
done
