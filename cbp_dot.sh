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

log_warn "Expand dotfiles"

log_info "git"
cbp dot -a cbp_dot/dot_gitconfig
cbp dot -a cbp_dot/dot_gitignore_global

log_info "latexmk"
cbp dot -a cbp_dot/dot_latexmkrc

log_info "perltidy"
cbp dot -a cbp_dot/dot_perltidyrc

log_info "tmux"
cbp dot -a cbp_dot/dot_tmux.conf

log_info "wget"
cbp dot -a cbp_dot/dot_wgetrc

# don't ruin Ubuntu
log_info "stwo-bash"
stow -t "${HOME}" stow-bash -v 2
