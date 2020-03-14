#!/usr/bin/env bash

# kent userApps v308 generates much different result for maf* stuffs that looks very wrong.
# So don’t use it.

mkdir -p $HOME/share/

rm -fr $HOME/bin/x86_64
rm -fr $HOME/share/kent

# download in 2011
cd $HOME/share/
if [ ! -e jksrc.zip ]; then
    wget -N https://github.com/wang-q/ubuntu/releases/download/20190906/jksrc.zip
fi

brew install mysql-client

PREFIX=$(brew --prefix mysql-client)
RELEASE=$( ( lsb_release -ds || cat /etc/*release || uname -om ) 2>/dev/null | head -n1 )
RELEASE_INFIX=ubuntu-1404

unzip jksrc.zip
cd $HOME/share/kent/src

if [[ `uname` == 'Darwin' ]]; then
    sed -i".bak" 's/CC\=gcc/CC\=gcc \-Wno\-return\-type/' inc/common.mk
    RELEASE_INFIX=darwin
else
    sed -i 's/CC\=gcc/CC\=gcc \-Wno\-error\=unused\-but\-set\-variable /' inc/common.mk
    if echo ${RELEASE} | grep CentOS > /dev/null ; then
        RELEASE_INFIX=centos-7
    fi
fi

# make
export MACHTYPE=x86_64
export MYSQLLIBS="-L${PREFIX}/lib -lmysqlclient -lz"
export MYSQLINC="${PREFIX}/include/mysql"

USE_SSL=0 make

# create tarball
cd $HOME/bin
tar cvfz jkbin-egaz-${RELEASE_INFIX}-2011.tar.gz \
    x86_64/axtChain \
    x86_64/axtSort \
    x86_64/axtToMaf \
    x86_64/chainAntiRepeat \
    x86_64/chainMergeSort \
    x86_64/chainNet \
    x86_64/chainPreNet \
    x86_64/chainSplit \
    x86_64/chainStitchId \
    x86_64/faToTwoBit \
    x86_64/lavToPsl \
    x86_64/netChainSubset \
    x86_64/netFilter \
    x86_64/netSplit \
    x86_64/netSyntenic \
    x86_64/netToAxt

mv jkbin-egaz-${RELEASE_INFIX}-2011.tar.gz $HOME/share/
