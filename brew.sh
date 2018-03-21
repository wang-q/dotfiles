#!/bin/bash

# perl
echo "==> Install Perl 5.22"
brew install wang-q/tap/perl@5.22.4
brew link --force wang-q/tap/perl@5.22.4

if grep -q -i PERL_522_PATH $HOME/.bashrc; then
    echo "==> .bashrc already contains PERL_522_PATH"
else
    echo "==> Updating .bashrc with PERL_522_PATH..."
    PERL_522_BREW=$(brew --prefix)/Cellar/$(brew list --versions wang-q/tap/perl@5.22.4 | sed 's/ /\//')
    PERL_522_PATH="export PATH=\"$PERL_518_BREW/bin:\$PATH\""
    BREW_SITE_PERL="export PERL5LIB=\"$(brew --prefix)/lib/perl5/site_perl:\$PERL5LIB\""
    echo '# PERL_522_PATH' >> $HOME/.bashrc
    echo $PERL_522_PATH    >> $HOME/.bashrc
    echo $BREW_SITE_PERL   >> $HOME/.bashrc
    echo >> $HOME/.bashrc

    # make the above environment variables available for the rest of this script
    eval $PERL_522_PATH
    eval $BREW_SITE_PERL
fi

curl -L https://cpanmin.us | perl - App::cpanminus

# python
echo "==> Install Python 2.7"

brew install python@2

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
brew link --force libffi

# development tools
brew install bfg cloc cmake

# other tools
brew install htop pandoc parallel pigz sqlite tree proxychains-ng

# gtk+3
brew install gsettings-desktop-schemas gtk+3 adwaita-icon-theme

# Graphics
brew install gnuplot graphviz imagemagick

# bioinformatics
brew install htslib bowtie2

# https://www.reddit.com/r/osx/comments/4ljbdq/mpv_tutorial_and_60_fps_playback_on_os_x/
# ffmpeg
brew install lame libvo-aacenc x264 xvid fdk-aac
brew install --without-harfbuzz libass
brew install --with-x265 --with-theora --with-rtmpdump --with-openssl \
    --with-libvorbis --with-libass --with-libbs2b --with-rubberband --with-fdk-aac \
    ffmpeg
