# .bash_profile

# Get the aliases and functions
if [ -f ~/.bashrc ]; then
    . ~/.bashrc
fi

source "$HOME/.cargo/env"

export PATH="/usr/local/opt/sqlite/bin:$PATH"
