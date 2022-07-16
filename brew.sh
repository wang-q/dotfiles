#!/bin/bash

export HOMEBREW_NO_AUTO_UPDATE=1
# export ALL_PROXY=socks5h://localhost:1080

# Clear caches
rm -f $(brew --cache)/*.incomplete

echo "==> gcc"
brew install gcc@5
brew install gcc
brew install gpatch pkg-config

# perl
echo "==> Install Perl 5.34"
brew install perl

if grep -q -i PERL_534_PATH $HOME/.bashrc; then
    echo "==> .bashrc already contains PERL_534_PATH"
else
    echo "==> Updating .bashrc with PERL_534_PATH..."
    PERL_534_BREW=$(brew --prefix)/Cellar/$(brew list --versions perl | sed 's/ /\//' | head -n 1)
    PERL_534_PATH="export PATH=\"$PERL_534_BREW/bin:\$PATH\""
    echo '# PERL_534_PATH' >> $HOME/.bashrc
    echo $PERL_534_PATH    >> $HOME/.bashrc
    echo >> $HOME/.bashrc

    # make the above environment variables available for the rest of this script
    eval $PERL_534_PATH
fi

hash cpanm 2>/dev/null || {
    curl -L https://cpanmin.us |
        perl - -v --mirror-only --mirror http://mirrors.ustc.edu.cn/CPAN/ App::cpanminus
}

# Some building tools
echo "==> Building tools"
brew install autoconf libtool automake # autogen
brew install cmake
brew install bison flex

# libs
brew install gd gsl jemalloc boost # fftw
brew install libffi libgit2 libxml2 libgcrypt libxslt
brew install pcre libedit readline sqlite nasm yasm
brew install bzip2 gzip libarchive libzip xz
# brew link --force libffi

# python
brew install python@3.9

if grep -q -i PYTHON_39_PATH $HOME/.bashrc; then
    echo "==> .bashrc already contains PYTHON_39_PATH"
else
    echo "==> Updating .bashrc with PYTHON_39_PATH..."
    PYTHON_39_PATH="export PATH=\"$(brew --prefix)/opt/python@3.9/bin:$(brew --prefix)/opt/python@3.9/libexec/bin:\$PATH\""
    echo '# PYTHON_39_PATH' >> $HOME/.bashrc
    echo ${PYTHON_39_PATH} >> $HOME/.bashrc
    echo >> $HOME/.bashrc

    # make the above environment variables available for the rest of this script
    eval ${PYTHON_39_PATH}
fi

# https://github.com/Homebrew/homebrew-core/issues/43867
# Upgrading pip breaks pip
#pip3 install --upgrade pip setuptools wheel

# r
# brew install wang-q/tap/r@3.6.1
hash R 2>/dev/null || {
    echo "==> Install R"
    brew install r
}

cpanm --mirror-only --mirror http://mirrors.ustc.edu.cn/CPAN/ --notest Statistics::R

# java
echo "==> Install Java"
if [[ "$OSTYPE" == "darwin"* ]]; then
    brew install openjdk
else
    brew install openjdk
    # brew link openjdk --force
fi
brew install ant maven

# pin these
# brew pin perl
# brew pin python@3.9
# brew pin r

# other programming languages
brew install lua node

# taps
brew tap wang-q/tap

# download tools
brew install aria2 curl wget

# gnu
brew install gnu-sed gnu-tar

# other tools
brew install screen stow htop parallel pigz
brew install tree pv
brew install jq pup datamash miller tsv-utils
brew install librsvg udunits
brew install proxychains-ng
brew install bat exa tealdeer # tiv
brew install hyperfine ripgrep tokei
brew install zellij bottom

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
