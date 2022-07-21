# .bashrc

# Source global definitions
if [ -f /etc/bashrc ]; then
    . /etc/bashrc
fi

# User specific aliases and functions

export PATH=/Library/TeX/texbin:$HOME/bin:$PATH
export PKG_CONFIG_PATH=/usr/local/lib/pkgconfig:/opt/X11/lib/pkgconfig/:$PKG_CONFIG_PATH

# Make vim the default editor.
export EDITOR='vim'

# Prefer US English and use UTF-8.
export LANG='en_US.UTF-8'
export LC_ALL='en_US.UTF-8'

# Don’t clear the screen after quitting a manual page.
export MANPAGER='less -X'

# colors
export PS1="\[\033[36m\]\u\[\033[m\]@\[\033[32m\]\h:\[\033[33;1m\]\w\[\033[m\]\$ "
export CLICOLOR=1
export LSCOLORS=ExFxBxDxCxegedabagacad

# some more ls aliases
alias ll='ls -alF'
alias la='ls -A'

# ASIS
export BASH_SILENCE_DEPRECATION_WARNING=1

# for headless chrome
alias chrome="/Applications/Google\ Chrome.app/Contents/MacOS/Google\ Chrome"

# mongodbbin
export PATH="$HOME/share/mongodb/bin:$PATH"

# mysqlbin
export PATH="$HOME/share/mysql/bin:$PATH"

# USTC mirror of Homebrew bottles
# https://lug.ustc.edu.cn/wiki/mirrors/help/homebrew-bottles
export HOMEBREW_NO_ANALYTICS=1
export HOMEBREW_BREW_GIT_REMOTE="https://mirrors.ustc.edu.cn/brew.git"
export HOMEBREW_CORE_GIT_REMOTE="https://mirrors.ustc.edu.cn/homebrew-core.git"
export HOMEBREW_BOTTLE_DOMAIN="https://mirrors.ustc.edu.cn/homebrew-bottles"

# RUST_PATH
export RUSTUP_DIST_SERVER=https://mirrors.ustc.edu.cn/rust-static
export RUSTUP_UPDATE_ROOT=https://mirrors.ustc.edu.cn/rust-static/rustup
export PATH="$HOME/.cargo/bin:$PATH"

source "$HOME/.cargo/env"

# Homebin
export PATH="$HOME/bin:$PATH"

export BLASTDB="$HOME/share/blast/db/"

# PERL_534_PATH
export PATH="/usr/local/Cellar/perl/5.34.0/bin:$PATH"

# PYTHON_39_PATH
export PATH="/usr/local/opt/python@3.9/bin:/usr/local/opt/python@3.9/libexec/bin:$PATH"
