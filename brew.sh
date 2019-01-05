#!/bin/bash

# perl
echo "==> Install Perl 5.28"
brew install perl

if grep -q -i PERL_528_PATH $HOME/.bashrc; then
    echo "==> .bashrc already contains PERL_528_PATH"
else
    echo "==> Updating .bashrc with PERL_528_PATH..."
    PERL_528_BREW=$(brew --prefix)/Cellar/$(brew list --versions perl | sed 's/ /\//')
    PERL_528_PATH="export PATH=\"$PERL_528_BREW/bin:\$PATH\""
    BREW_SITE_PERL="export PERL5LIB=\"$(brew --prefix)/lib/perl5/site_perl:\$PERL5LIB\""
    echo '# PERL_528_PATH' >> $HOME/.bashrc
    echo $PERL_528_PATH    >> $HOME/.bashrc
    echo $BREW_SITE_PERL   >> $HOME/.bashrc
    echo >> $HOME/.bashrc

    # make the above environment variables available for the rest of this script
    eval $PERL_528_PATH
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

pip3 install --upgrade pip setuptools

# r
brew install r

# java
brew install jdk
brew install ant maven

# pin these
brew pin perl
brew pin python
brew pin r
brew pin jdk

# other programming languages
brew install lua node

# download tools
brew install aria2 curl wget

# gnu
brew install gnu-sed gnu-tar

# libs
brew install berkeley-db gd gsl libffi libgit2 libxml2 libxslt pcre readline sqlite yasm
# brew link --force libffi

# other tools
brew install gpg2
brew install cloc cmake htop pandoc parallel pigz tree
brew install jq jo pup datamash miller tsv-utils

# Graphics
brew install gnuplot graphviz imagemagick

# weird dependancies by Cairo.pm
# brew install linuxbrew/xorg/libpthread-stubs linuxbrew/xorg/renderproto linuxbrew/xorg/kbproto linuxbrew/xorg/xextproto

# gtk+3
brew install gsettings-desktop-schemas gtk+3 adwaita-icon-theme gobject-introspection
