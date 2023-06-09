#!/bin/bash

BASE_DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )

RELEASE=$( ( lsb_release -ds || cat /etc/*release || uname -om ) 2>/dev/null | head -n1 )
if [[ $(uname) == 'Darwin' ]]; then
    # Python itself
    brew install pkg-config
    brew install mpdecimal
    brew install openssl@1.1
    brew install sqlite
    brew install xz

    # pip
    brew install hdf5
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
        sudo apt -y build-dep python3-dev

        sudo apt -y install libgdbm-dev sqlite3 libsqlite3-dev libssl-dev libffi-dev
    fi
fi

mkdir -p $HOME/share/Python

cd
curl -L https://mirrors.huaweicloud.com/python/3.9.13/Python-3.9.13.tgz |
    tar xvz
cd Python-3.9.13

if [[ $(uname) == 'Darwin' ]]; then
    CC=gcc \
    LDFLAGS="-L$(brew --prefix sqlite)/lib" \
    CPPFLAGS="-I$(brew --prefix sqlite)/include" \
    ./configure \
        --prefix=$HOME/share/Python \
        --enable-optimizations \
        --enable-ipv6 \
        --with-openssl=$(brew --prefix openssl@1.1) \
        --enable-loadable-sqlite-extensions \
        --with-lto

else
    CC=gcc ./configure \
        --prefix=$HOME/share/Python \
        --enable-optimizations \
        --enable-ipv6 \
        --enable-loadable-sqlite-extensions \
        --with-lto

fi

make -j 8
# make test
make install

cd
rm -fr ~/Python-3.9.13

if grep -q -i PYTHON_39_PATH $HOME/.bashrc; then
    echo "==> .bashrc already contains PYTHON_39_PATH"
else
    echo "==> Updating .bashrc with PYTHON_39_PATH..."
    PYTHON_39_PATH="export PATH=\"\$HOME/share/Python/bin:\$PATH\""
    echo '# PYTHON_39_PATH' >> $HOME/.bashrc
    echo $PYTHON_39_PATH    >> $HOME/.bashrc
    echo >> $HOME/.bashrc

    eval $PYTHON_39_PATH
fi

source ~/.bashrc

ALL_PROXY= ~/share/Python/bin/python3 -m pip install \
    --trusted-host mirror.nju.edu.cn \
    -i http://mirror.nju.edu.cn/pypi/web/simple/ \
    --upgrade pip setuptools wheel pysocks
