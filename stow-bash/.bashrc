# .bashrc

# Source global definitions
if [ -f /etc/bashrc ]; then
    . /etc/bashrc
fi

# User specific aliases and functions

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

# sqlite
export PATH="/opt/homebrew/opt/sqlite/bin:$PATH"

# USTC mirror of Homebrew bottles
export HOMEBREW_NO_ANALYTICS=1
eval "$(/opt/homebrew/bin/brew shellenv)"

# RUST_PATH
export PATH="$HOME/.cargo/bin:$PATH"

source "$HOME/.cargo/env"

# Homebin
export PATH="$HOME/bin:$PATH"

# PERL_534_PATH
export PATH="$HOME/share/Perl/bin:$PATH"

# R_42_PATH
export PATH="/usr/local/bin:$PATH"

# PYTHON_310_PATH
export PATH="$HOME/share/Python/bin:$PATH"

. "$HOME/.cargo/env"
# .cbp
export PATH="$HOME/.cbp/bin:$PATH"
