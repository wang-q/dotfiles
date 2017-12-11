#!/bin/bash

# download tools
brew install aria2 curl wget

# gnu
brew install gnu-sed gnu-tar

# perl
brew install perl@5.18
brew link --force perl@5.18

if grep -q -i PERL_518_PATH $HOME/.bashrc; then
    echo "==> .bashrc already contains PERL_518_PATH"
else
    echo "==> Updating .bashrc with PERL_518_PATH..."
    PERL_518_BREW=$(brew --prefix)/Cellar/$(brew list --versions perl@5.18 | sed 's/ /\//')
    PERL_518_PATH="export PATH=\"$PERL_518_BREW/bin:\$PATH\""
    BREW_SITE_PERL="export PERL5LIB=\"$(brew --prefix)/lib/perl5/site_perl:\$PERL5LIB\""
    echo '# PERL_518_PATH' >> $HOME/.bashrc
    echo $PERL_518_PATH    >> $HOME/.bashrc
    echo $BREW_SITE_PERL   >> $HOME/.bashrc
    echo >> $HOME/.bashrc

    # make the above environment variables available for the rest of this script
    eval $PERL_518_PATH
    eval $BREW_SITE_PERL
fi

curl -L https://cpanmin.us | perl - App::cpanminus

# python
brew install python

if grep -q -i PYTHON_27_PATH $HOME/.bashrc; then
    echo "==> .bashrc already contains PYTHON_27_PATH"
else
    echo "==> Updating .bashrc with PYTHON_27_PATH..."
    PYTHON_27_PATH="export PATH=\"$(brew --prefix)/opt/python/libexec/bin:\$PATH\""
    echo '# PYTHON_27_PATH' >> $HOME/.bashrc
    echo $PYTHON_27_PATH    >> $HOME/.bashrc
    echo >> $HOME/.bashrc

    # make the above environment variables available for the rest of this script
    eval $PYTHON_27_PATH
fi

pip install --upgrade pip setuptools

# java
brew install jdk@8
brew link --force jdk@8
brew install maven ant

# other programming languages
brew install lua node

# libs
brew install berkeley-db gd gsl libffi libxml2 libxslt pcre readline yasm

# development tools
brew install bfg cloc cmake

# other tools
brew install htop pandoc parallel pigz sqlite tree proxychains-ng nmap

# gtk+3
brew install gsettings-desktop-schemas gtk+3 adwaita-icon-theme

# Graphics
brew install gnuplot graphviz imagemagick

# https://www.reddit.com/r/osx/comments/4ljbdq/mpv_tutorial_and_60_fps_playback_on_os_x/
# ffmpeg
brew install lame libvo-aacenc x264 xvid fdk-aac
brew install --without-harfbuzz libass
brew install --with-x265 --with-theora --with-rtmpdump --with-openssl \
    --with-libvorbis --with-libass --with-libbs2b --with-rubberband --with-fdk-aac \
    ffmpeg
