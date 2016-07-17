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

# plenv
export PATH="$HOME/.plenv/bin:$PATH"
eval "$(plenv init -)"

# vcftools
export PERL5LIB=/usr/local/lib/perl5/site_perl:${PERL5LIB}

# FreeBSD ls colors
export CLICOLOR=1

# mongodbbin
export PATH="$HOME/share/mongodb/bin:$PATH"

# mysqlbin
export PATH="$HOME/share/mysql/bin:$PATH"
