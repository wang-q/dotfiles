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

# for headless chrome
alias chrome="/Applications/Google\ Chrome.app/Contents/MacOS/Google\ Chrome"

# mongodbbin
export PATH="$HOME/share/mongodb/bin:$PATH"

# mysqlbin
export PATH="$HOME/share/mysql/bin:$PATH"

# ustc mirror of Homebrew bottles
# https://lug.ustc.edu.cn/wiki/mirrors/help/homebrew-bottles
export HOMEBREW_NO_ANALYTICS=1
export HOMEBREW_NO_AUTO_UPDATE=1
export HOMEBREW_BOTTLE_DOMAIN=https://mirrors.ustc.edu.cn/homebrew-bottles

# PYTHON_3_PATH
export PATH="/usr/local/opt/python/libexec/bin:$PATH"

# PERL_528_PATH
export PATH="/usr/local/Cellar/perl/5.28.1/bin:$PATH"
export PERL5LIB="/usr/local/lib/perl5/site_perl:$PERL5LIB"

