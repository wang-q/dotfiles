#!/usr/bin/env bash

echo "====> Download Genomics related tools <===="

mkdir -p $HOME/bin
mkdir -p $HOME/.local/bin
mkdir -p $HOME/share
mkdir -p $HOME/Scripts

# make sure $HOME/bin in your $PATH
if grep -q -i homebin $HOME/.bashrc; then
    echo "==> .bashrc already contains homebin"
else
    echo "==> Update .bashrc"

    HOME_PATH='export PATH="$HOME/bin:$HOME/.local/bin:$PATH"'
    echo '# Homebin' >> $HOME/.bashrc
    echo $HOME_PATH >> $HOME/.bashrc
    echo >> $HOME/.bashrc

    eval $HOME_PATH
fi

# Clone or pull other repos
for OP in dotfiles alignDB withncbi; do
    if [[ ! -d "$HOME/Scripts/$OP/.git" ]]; then
        if [[ ! -d "$HOME/Scripts/$OP" ]]; then
            echo "==> Clone $OP"
            git clone https://github.com/wang-q/${OP}.git "$HOME/Scripts/$OP"
        else
            echo "==> $OP exists"
        fi
    else
        echo "==> Pull $OP"
        pushd "$HOME/Scripts/$OP" > /dev/null
        git pull
        popd > /dev/null
    fi
done

# alignDB
chmod +x $HOME/Scripts/alignDB/alignDB.pl
ln -fs $HOME/Scripts/alignDB/alignDB.pl $HOME/bin/alignDB.pl

echo "==> Jim Kent bin"
cd $HOME/bin/
RELEASE=$( ( lsb_release -ds || cat /etc/*release || uname -om ) 2>/dev/null | head -n1 )
if [[ $(uname) == 'Darwin' ]]; then
    JKBIN_TAR_GZ=/tmp/jkbin-egaz-darwin-2011.tar.gz
    if [ ! -e ${JKBIN_TAR_GZ} ]; then
        wget -N -P /tmp https://github.com/wang-q/ubuntu/releases/download/20190906/jkbin-egaz-darwin-2011.tar.gz
    fi
else
    if echo ${RELEASE} | grep CentOS > /dev/null ; then
        JKBIN_TAR_GZ=/tmp/jkbin-egaz-centos-7-2011.tar.gz
        if [ ! -e ${JKBIN_TAR_GZ} ]; then
            wget -N -P /tmp https://github.com/wang-q/ubuntu/releases/download/20190906/jkbin-egaz-centos-7-2011.tar.gz
        fi
    else
        JKBIN_TAR_GZ=/tmp/jkbin-egaz-ubuntu-1404-2011.tar.gz
        if [ ! -e ${JKBIN_TAR_GZ} ]; then
            wget -N -P /tmp https://github.com/wang-q/ubuntu/releases/download/20190906/jkbin-egaz-ubuntu-1404-2011.tar.gz
        fi
    fi
fi

echo "==> untar from ${JKBIN_TAR_GZ}"
tar xvfz ${JKBIN_TAR_GZ} x86_64/axtChain
tar xvfz ${JKBIN_TAR_GZ} x86_64/axtSort
tar xvfz ${JKBIN_TAR_GZ} x86_64/axtToMaf
tar xvfz ${JKBIN_TAR_GZ} x86_64/chainAntiRepeat
tar xvfz ${JKBIN_TAR_GZ} x86_64/chainMergeSort
tar xvfz ${JKBIN_TAR_GZ} x86_64/chainNet
tar xvfz ${JKBIN_TAR_GZ} x86_64/chainPreNet
tar xvfz ${JKBIN_TAR_GZ} x86_64/chainSplit
tar xvfz ${JKBIN_TAR_GZ} x86_64/chainStitchId
tar xvfz ${JKBIN_TAR_GZ} x86_64/faToTwoBit
tar xvfz ${JKBIN_TAR_GZ} x86_64/lavToPsl
tar xvfz ${JKBIN_TAR_GZ} x86_64/netChainSubset
tar xvfz ${JKBIN_TAR_GZ} x86_64/netFilter
tar xvfz ${JKBIN_TAR_GZ} x86_64/netSplit
tar xvfz ${JKBIN_TAR_GZ} x86_64/netSyntenic
tar xvfz ${JKBIN_TAR_GZ} x86_64/netToAxt

mv $HOME/bin/x86_64/* $HOME/bin/

if [[ $(uname) == 'Darwin' ]]; then
    wget -N http://hgdownload.soe.ucsc.edu/admin/exe/macOSX.x86_64/faToTwoBit
    chmod +x faToTwoBit
else
    wget -N http://hgdownload.soe.ucsc.edu/admin/exe/linux.x86_64/faToTwoBit
    chmod +x faToTwoBit
fi
mv faToTwoBit $HOME/bin/

echo "==> TrimGalore"
curl -O https://raw.githubusercontent.com/FelixKrueger/TrimGalore/master/trim_galore
mv trim_galore $HOME/bin
chmod +x $HOME/bin/trim_galore

echo "==> circos-tools"
wget -N -P /tmp http://circos.ca/distribution/circos-tools-0.22.tgz

cd $HOME/share/
rm -fr circos-tools
tar xvfz /tmp/circos-tools-0.22.tgz
mv circos-tools-0.22 circos-tools
