#!/bin/bash

# perl
echo "==> Install Perl 5.26"
brew install perl

if grep -q -i PERL_526_PATH $HOME/.bashrc; then
    echo "==> .bashrc already contains PERL_526_PATH"
else
    echo "==> Updating .bashrc with PERL_526_PATH..."
    PERL_526_BREW=$(brew --prefix)/Cellar/$(brew list --versions perl | sed 's/ /\//')
    PERL_526_PATH="export PATH=\"$PERL_526_BREW/bin:\$PATH\""
    BREW_SITE_PERL="export PERL5LIB=\"$(brew --prefix)/lib/perl5/site_perl:\$PERL5LIB\""
    echo '# PERL_526_PATH' >> $HOME/.bashrc
    echo $PERL_526_PATH    >> $HOME/.bashrc
    echo $BREW_SITE_PERL   >> $HOME/.bashrc
    echo >> $HOME/.bashrc

    # make the above environment variables available for the rest of this script
    eval $PERL_526_PATH
    eval $BREW_SITE_PERL
fi

curl -L https://cpanmin.us | perl - App::cpanminus

# python
echo "==> Install Python 3"
brew install python

if grep -q -i PYTHON_3_PATH $HOME/.bashrc; then
    echo "==> .bashrc already contains PYTHON_3_PATH"
else
    echo "==> Updating .bashrc with PYTHON_3_PATH..."
    PYTHON_3_PATH="export PATH=\"$(brew --prefix)/opt/python/libexec/bin:\$PATH\""
    echo '# PYTHON_3_PATH' >> $HOME/.bashrc
    echo $PYTHON_3_PATH    >> $HOME/.bashrc
    echo >> $HOME/.bashrc

    # make the above environment variables available for the rest of this script
    eval $PYTHON_3_PATH
fi

pip install --upgrade pip setuptools

# r
brew install r

# java
brew install jdk
brew install ant maven

# other programming languages
brew install lua node

# download tools
brew install aria2 curl wget

# gnu
brew install gnu-sed gnu-tar

# libs
brew install berkeley-db gd gsl libffi libxml2 libxslt pcre readline yasm
# brew link --force libffi

# other tools
brew install cloc cmake htop pandoc parallel pigz sqlite tree

# Graphics
brew install gnuplot graphviz imagemagick

# weird dependancies by Cairo.pm
# brew install linuxbrew/xorg/libpthread-stubs linuxbrew/xorg/renderproto linuxbrew/xorg/kbproto linuxbrew/xorg/xextproto

# gtk+3
brew install gsettings-desktop-schemas gtk+3 adwaita-icon-theme
