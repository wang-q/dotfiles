#!/bin/bash

BASE_DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )

RELEASE=$( ( lsb_release -ds || cat /etc/*release || uname -om ) 2>/dev/null | head -n1 )
if [[ $(uname) == 'Darwin' ]]; then
    # R itself
    echo "Use the official build"
    echo "https://mirrors.tuna.tsinghua.edu.cn/CRAN/bin/macosx/big-sur-arm64/base/R-4.2.2-arm64.pkg"

    # packages
    brew install cmake
    brew install udunits
    #    brew install gdal # Huge
    exit
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
        sudo apt -y install gfortran

        sudo apt -y install groff-base libxml2-dev gettext
        sudo apt -y install libblas-dev liblapack-dev
        sudo apt -y install libcurl4-openssl-dev libncurses5-dev libreadline-dev
        sudo apt -y install libcairo2-dev libjpeg-dev libpango1.0-dev libpng-dev libtiff5-dev
        sudo apt -y install libbz2-dev liblzma-dev zlib1g-dev

        sudo apt -y install ghostscript libfreetype-dev fontconfig

        # udunit2, gdal
        sudo apt -y install cmake
        sudo apt -y install udunits-bin libudunits2-dev
        sudo apt -y install gdal-bin libgdal-dev

        # brewed binaries confuse configure
        hash brew 2>/dev/null && {
            brew unlink pkg-config
        }

    fi
fi

# This command will install texlive
# sudo apt -y build-dep r-base

# sudo apt install apt-rdepends
# apt-rdepends --build-depends --print-state --follow=DEPENDS r-base


mkdir -p $HOME/share/R

cd
curl -L https://mirrors.ustc.edu.cn/CRAN/src/base/R-4/R-4.3.0.tar.gz |
    tar xvz
cd R-4.3.0

hash gcc-9 2>/dev/null
if [ $? == '0' ]; then
    export CC=gcc-9
    export CXX=g++-9
    export FC=gfortran-9
else
    export CC=gcc
    export CXX=g++
    export FC=gfortran
fi

./configure \
    --prefix="$HOME/share/R" \
    --enable-memory-profiling \
    --disable-java \
    --with-pcre1 \
    --with-blas \
    --with-lapack \
    --without-x \
    --without-tcltk \
    --without-ICU \
    --with-cairo \
    --with-libpng \
    --with-jpeglib \
    --with-libtiff \
    --with-gnu-ld

make -j 8

bin/Rscript -e '
    capabilities();
    png("test.png");
    plot(rnorm(4000),rnorm(4000),col="#ff000018",pch=19,cex=2);
    dev.off();
    '

make install

cd
rm -fr ~/R-4.3.0

if grep -q -i R_4_PATH $HOME/.bashrc; then
    echo "==> .bashrc already contains R_4_PATH"
else
    echo "==> Updating .bashrc with R_4_PATH..."
    R_4_PATH="export PATH=\"\$HOME/share/R/bin:\$PATH\""
    echo '# R_4_PATH' >> $HOME/.bashrc
    echo $R_4_PATH    >> $HOME/.bashrc
    echo >> $HOME/.bashrc

    eval $R_4_PATH
fi

source ~/.bashrc
