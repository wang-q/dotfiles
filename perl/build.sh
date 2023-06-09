#!/bin/bash

BASE_DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )

RELEASE=$( ( lsb_release -ds || cat /etc/*release || uname -om ) 2>/dev/null | head -n1 )
if [[ $(uname) == 'Darwin' ]]; then
    # Perl itself
    brew install pkg-config
    brew install berkeley-db
    brew install gdbm

    # cpan
    brew install gd
    brew install openssl@1.1
    brew install zlib
else
    if echo ${RELEASE} | grep CentOS > /dev/null ; then
        # Manually
        echo "You should build all items manually under CentOS"
    else
        # source URI
        sudo cp /etc/apt/sources.list /etc/apt/sources.list~
        sudo sed -Ei 's/^# deb-src /deb-src /' /etc/apt/sources.list
        sudo sed -i 's/archive.ubuntu.com/mirrors.ustc.edu.cn/g' /etc/apt/sources.list

        sudo apt -y update

        sudo apt -y install build-essential
        sudo apt -y install file netbase procps
        sudo apt -y install cpio libbz2-dev libz-dev zlib1g-dev
        sudo apt -y install libdb-dev libgdbm-dev libssl-dev libexpat1
    fi
fi

#sudo apt -y build-dep perl

# sudo apt install apt-rdepends
# apt-rdepends --build-depends --print-state --follow=DEPENDS perl

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
# make test
make install

cd
rm -fr ~/perl-5.34.1

if grep -q -i PERL_534_PATH $HOME/.bashrc; then
    echo "==> .bashrc already contains PERL_534_PATH"
else
    echo "==> Updating .bashrc with PERL_534_PATH..."
    PERL_534_PATH="export PATH=\"\$HOME/share/Perl/bin:\$PATH\""
    echo '# PERL_534_PATH' >> $HOME/.bashrc
    echo $PERL_534_PATH    >> $HOME/.bashrc
    echo >> $HOME/.bashrc

    eval $PERL_534_PATH
fi

source ~/.bashrc

curl -L https://cpanmin.us |
    $HOME/share/Perl/bin/perl - -v --mirror-only --mirror http://mirrors.ustc.edu.cn/CPAN/ App::cpanminus
