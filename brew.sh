#!/bin/bash

# gcc
brew install gcc@4.8
brew unlink gcc@4.8

# download tools
brew install aria2 curl wget

# gnu
brew install gnu-sed gnu-tar

# libs
brew install berkeley-db gd gsl libffi libxml2 libxslt pcre readline yasm

# perl
brew install perl@5.18
brew link --force perl@5.18

if grep -q -i PERL_518_PATH $HOME/.bashrc; then
    echo "==> .bashrc already contains PERL_518_PATH"
else
    echo "==> Updating .bashrc with PERL_518_PATH..."
    PERL_518_BREW=$(brew --prefix)/Cellar/$(brew list --versions perl@5.18 | sed 's/ /\//')
    PERL_518_PATH="export PATH=\"$PERL_518_BREW/bin:\$PATH\""
    BREW_SITE_PERL='export PERL5LIB="/usr/local/lib/perl5/site_perl:$PERL5LIB"'
    echo '# PERL_518_PATH' >> $HOME/.bashrc
    echo $PERL_518_PATH >> $HOME/.bashrc
    echo $BREW_SITE_PERL >> $HOME/.bashrc
    echo >> $HOME/.bashrc

    # make the above available for the rest of this script
    eval $PERL_518_PATH
fi

# development tools
brew install bfg cloc cmake

# other tools
brew install htop-osx pandoc parallel pigz sqlite tree proxychains-ng nmap

# gtk+3
brew install gsettings-desktop-schemas gtk+3 gnome-icon-theme

# Graphics
brew install gnuplot graphviz imagemagick

# other programming languages
brew install maven ant
brew install lua node
brew install python
pip install --upgrade pip setuptools

brew tap homebrew/science
brew install r --without-tcltk --without-x11

# https://www.reddit.com/r/osx/comments/4ljbdq/mpv_tutorial_and_60_fps_playback_on_os_x/
# ffmpeg
brew install lame libvo-aacenc x264 xvid fdk-aac
brew install --without-harfbuzz libass
brew install --with-x265 --with-theora --with-rtmpdump --with-openssl \
    --with-libvorbis --with-libass --with-libbs2b --with-rubberband --with-fdk-aac \
    ffmpeg
