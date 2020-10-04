#!/bin/bash

# Clear caches
rm -f $(brew --cache)/*.incomplete

# perl
echo "==> Install Perl 5.32"
brew install perl

if grep -q -i PERL_532_PATH $HOME/.bashrc; then
    echo "==> .bashrc already contains PERL_532_PATH"
else
    echo "==> Updating .bashrc with PERL_532_PATH..."
    PERL_532_BREW=$(brew --prefix)/Cellar/$(brew list --versions perl | sed 's/ /\//' | head -n 1)
    PERL_532_PATH="export PATH=\"$PERL_532_BREW/bin:\$PATH\""
    echo '# PERL_532_PATH' >> $HOME/.bashrc
    echo $PERL_532_PATH    >> $HOME/.bashrc
    echo >> $HOME/.bashrc

    # make the above environment variables available for the rest of this script
    eval $PERL_532_PATH
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
# brew install wang-q/tap/r@3.6.1
hash Rscript 2>/dev/null || {
    echo "==> Install R"
    brew install r
}

cpanm --mirror-only --mirror http://mirrors.ustc.edu.cn/CPAN/ --notest Statistics::R

# java
echo "==> Install Java"
if [[ "$OSTYPE" == "darwin"* ]]; then
    brew tap homebrew/cask
    brew cask install adoptopenjdk
else
    brew install adoptopenjdk
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
brew install screen stow
brew install cloc cmake htop parallel pigz tldr tree
brew install jq pup datamash miller tsv-utils
brew install hyperfine ripgrep

# large packages
if [[ "$OSTYPE" == "darwin"* ]]; then
    brew install gpg2
fi

hash pandoc 2>/dev/null || {
    brew install pandoc
}

hash gnuplot 2>/dev/null || {
    brew install gnuplot
}

hash dot 2>/dev/null || {
    brew install graphviz
}

hash convert 2>/dev/null || {
    brew install imagemagick
}

# weird dependancies by Cairo.pm
# brew install linuxbrew/xorg/libpthread-stubs linuxbrew/xorg/renderproto linuxbrew/xorg/kbproto linuxbrew/xorg/xextproto

# gtk+3
# brew install gsettings-desktop-schemas gtk+3 adwaita-icon-theme gobject-introspection
