#!/bin/bash

# # gcc
# brew install gcc
# brew install gcc@5

# if [[ "$OSTYPE" == "darwin"* ]]; then
#     echo "==> Create gcc symlinks..."
#     GCC_POSTFIX=$(brew list gcc@5 | grep -E '/bin/gcc\-\d.*' | grep -E -o '\-\d.*$')
#     GCC_BREW=$(brew --prefix)/Cellar/$(brew list --versions gcc@5 | sed 's/ /\//')
#     BREW_BIN="$(brew --prefix)/bin"

#     LN_APPS="c++ cpp g++ gcc gcc-ar gcc-nm gcc-ranlib gcov"
#     for app in $LN_APPS; do
#         LN_NAME=$BREW_BIN/$(echo $app)
#         if [ -L $LN_NAME ]; then
#             rm $LN_NAME
#         fi
#         ln -s "${GCC_BREW}/bin/${app}${GCC_POSTFIX}" $LN_NAME
#     done

#     ln -s "${BREW_BIN}/gcc" "${BREW_BIN}/cc"
# fi

# Clear caches
rm -f $(brew --cache)/*.incomplete

# perl
echo "==> Install Perl 5.30"
brew install perl

if grep -q -i PERL_530_PATH $HOME/.bashrc; then
    echo "==> .bashrc already contains PERL_530_PATH"
else
    echo "==> Updating .bashrc with PERL_530_PATH..."
    PERL_530_BREW=$(brew --prefix)/Cellar/$(brew list --versions perl | sed 's/ /\//')
    PERL_530_PATH="export PATH=\"$PERL_530_BREW/bin:\$PATH\""
    BREW_SITE_PERL="export PERL5LIB=\"$(brew --prefix)/lib/perl5/site_perl:\$PERL5LIB\""
    echo '# PERL_530_PATH' >> $HOME/.bashrc
    echo $PERL_530_PATH    >> $HOME/.bashrc
    echo $BREW_SITE_PERL   >> $HOME/.bashrc
    echo >> $HOME/.bashrc

    # make the above environment variables available for the rest of this script
    eval $PERL_530_PATH
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
echo "==> Install R"
if [[ "$OSTYPE" == "darwin"* ]]; then
    brew install r
else
    brew install r #--without-xorg
fi

cpanm --mirror-only --mirror http://mirrors.ustc.edu.cn/CPAN/ --notest Statistics::R

# java
echo "==> Install Java"
if [[ "$OSTYPE" == "darwin"* ]]; then
    brew tap caskroom/cask
    brew cask install java
else
    brew install jdk
    brew pin jdk
fi
brew install ant maven

# pin these
brew pin perl
brew pin python
brew pin r

# other programming languages
brew install lua node

# taps
brew tap wang-q/tap

# download tools
brew install aria2 curl wget

# gnu
brew install gnu-sed gnu-tar

# libs
brew install berkeley-db gd gsl libffi libgit2 libxml2 libxslt pcre readline sqlite yasm
# brew link --force libffi

# other tools
brew install gpg2 stow
brew install cloc cmake htop pandoc parallel pigz tldr tree
brew install jq jo pup datamash miller tsv-utils

# Graphics
brew install gnuplot graphviz imagemagick

# weird dependancies by Cairo.pm
# brew install linuxbrew/xorg/libpthread-stubs linuxbrew/xorg/renderproto linuxbrew/xorg/kbproto linuxbrew/xorg/xextproto

# gtk+3
brew install gsettings-desktop-schemas gtk+3 adwaita-icon-theme gobject-introspection
