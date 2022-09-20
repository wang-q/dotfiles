#!/bin/bash

BASE_DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )

# source URI
sudo cp /etc/apt/sources.list /etc/apt/sources.list~
sudo sed -Ei 's/^# deb-src /deb-src /' /etc/apt/sources.list
sudo sed -i 's/archive.ubuntu.com/mirrors.ustc.edu.cn/g' /etc/apt/sources.list

sudo apt -y update

sudo apt -y build-dep perl

sudo apt -y install libgdbm-dev libssl-dev libexpat1

mkdir -p $HOME/share/Perl

cd
curl -L https://mirrors.ustc.edu.cn/CPAN/src/5.0/perl-5.34.1.tar.gz |
    tar xvz
cd perl-5.34.1

./Configure \
    -des \
    -Dprefix=$HOME/share/Perl \
    -Dcc=gcc \
    -Duseshrplib \
    -Duselargefiles \
    -Dusethreads

make -j 8
make test
make install

cd
rm -fr ~/perl-5.34.1

if grep -q -i PERL_534_PATH $HOME/.bashrc; then
    echo "==> .bashrc already contains PERL_534_PATH"
else
    echo "==> Updating .bashrc with PERL_534_PATH..."
    PERL_534_PATH="export PATH=\"$HOME/share/Perl/bin:\$PATH\""
    echo '# PERL_534_PATH' >> $HOME/.bashrc
    echo $PERL_534_PATH    >> $HOME/.bashrc
    echo >> $HOME/.bashrc
fi

source ~/.bashrc

curl -L https://cpanmin.us |
    perl - -v --mirror-only --mirror http://mirrors.ustc.edu.cn/CPAN/ App::cpanminus
