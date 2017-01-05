# .bashrc

# Source global definitions
if [ -f /etc/bashrc ]; then
    . /etc/bashrc
fi

# User specific aliases and functions

export PATH=/Library/TeX/texbin:$HOME/bin:$PATH
export INCLUDE=$HOME/inlcude:$INCLUDE
export LIB=$HOME/lib:$LIB
export PKG_CONFIG_PATH=$HOME/lib/pkgconfig:/usr/local/lib/pkgconfig:/opt/X11/lib/pkgconfig/:$PKG_CONFIG_PATH

# Make vim the default editor.
export EDITOR='vim'

# Prefer US English and use UTF-8.
export LANG='en_US.UTF-8'
export LC_ALL='en_US.UTF-8'

# Don’t clear the screen after quitting a manual page.
export MANPAGER='less -X'

# FreeBSD ls colors
export CLICOLOR=1

# plenv
export PATH="$HOME/.plenv/bin:$PATH"
eval "$(plenv init -)"

# vcftools
export PERL5LIB=/usr/local/lib/perl5/site_perl:${PERL5LIB}

# mongodbbin
export PATH="$HOME/share/mongodb/bin:$PATH"

# mysqlbin
export PATH="$HOME/share/mysql/bin:$PATH"

# ustc mirror of Homebrew bottles
# https://lug.ustc.edu.cn/wiki/mirrors/help/homebrew-bottles
export HOMEBREW_BOTTLE_DOMAIN=https://mirrors.ustc.edu.cn/homebrew-bottles
