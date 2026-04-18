# CentOS 7

<!-- TOC -->
* [CentOS 7](#centos-7)
  * [Install the system](#install-the-system)
    * [In WSL](#in-wsl)
    * [In VMware/Parallels](#in-vmwareparallels)
  * [As `root`](#as-root)
    * [Install libraries](#install-libraries)
    * [Change the Home directory](#change-the-home-directory)
    * [Sudo](#sudo)
    * [Backup WSL](#backup-wsl)
  * [CentS](#cents)
    * [cbp](#cbp)
    * [Perl, Python, and Java](#perl-python-and-java)
    * [Perl modules](#perl-modules)
    * [spades](#spades)
    * [nwr](#nwr)
    * [Backup WSL](#backup-wsl-1)
  * [CentH](#centh)
    * [gcc and commonly used libraries](#gcc-and-commonly-used-libraries)
    * [R Packages](#r-packages)
    * [Backup WSL](#backup-wsl-2)
  * [My modules](#my-modules)
  * [.ssh](#ssh)
  * [Mirror to remote server](#mirror-to-remote-server)
  * [Old codes](#old-codes)
    * [curl](#curl)
    * [Change the hostname](#change-the-hostname)
    * [R with system `libc`](#r-with-system-libc)
    * [Old R](#old-r)
<!-- TOC -->

We will build several VMs here:

1. `centos.tar` - a VM exported from docker images

2. `centos.root.tar` - Mimic after the HPCC of NJU; wangq as the default user

3. `CentS` - system gcc and yum packages, linked to the system libc
    * `Perl`
    * `Python`
    * A minimal `R`
    * `rustup`
        * Homebrew bottled rust packages can't be used as they need GLIBC 2.18

4. `CentH` - everything else in Homebrew is linked to the brewed glibc
    * `R` compiled by gcc@9

## Install the system

### In WSL

This one is preferred.

https://learn.microsoft.com/en-us/windows/wsl/use-custom-distro

* Install Docker Desktop on Windows
    * Use WSL 2
    * Settings -> Resources -> WSL integration -> Tick Ubuntu

```bash
docker pull wangq/centos:master

# An arbitrary command to generate a container
docker run -t wangq/centos:master bash -c 'ls -l /'

dockerContainerID=$(docker container ls -a | grep -i centos | awk '{print $1}')

mkdir -p /mnt/c/Users/wangq/VM
docker export $dockerContainerID > /mnt/c/Users/wangq/VM/centos.tar

```

```powershell
wsl --import CentOS $HOME\VM\CentOS $HOME\VM\centos.tar

# list all VMs
wsl -l -v

# Start CentOS
wsl -d CentOS

# wsl --terminate CentOS # To refresh wsl.conf

```

### In VMware/Parallels

```bash
wget -N https://mirrors.nju.edu.cn/centos/7/isos/x86_64/CentOS-7-x86_64-DVD-2207-02.iso

```

In VMware/Parallels, Customize the VM hardware before installation as 4 or more cores, 4GB RAM, 80G
disk, 800x600 screen and Bridged Network (Default Adapter). Remove all unnecessary devices, e.g.
printer, camera, or sound card.

Settings at installation:

* Asia/Shanghai
* Minimal installation
* Don't use LVM and don't set the `/home` mount point

## As `root`

### Install libraries

SSH in as `root`.

Present in the HPCC, `yum list installed | grep XXX`

* blas, lapack
* bzip2-devel
* openssl-devel
* libcurl-devel
* pcre-devel
* libffi-devel
* sqlite-devel
* ncurses-devel
* readline-devel
* libuuid-devel
* gd

* ghostscript
* `/usr/bin/java -version` openjdk version "1.8.0_222-ea"

Absent:

* pcre2-devel
* cairo-devel
* udunits2
* gdal
* imagemagick
* gnuplot

```bash
# Most required basic packages are already installed in the docker image
yum -y upgrade

# Install newer versions of git and curl
# Linuxbrew need git 2.7.0 and cURL 7.41.0
git --version
# git version 2.41.0

# R
yum install -y ghostscript
yum install -y cairo-devel pango-devel # HPCC has no -devel
yum install -y gd gd-devel

# locate
yum install -y mlocate
updatedb

```

### Change the Home directory

`usermod` is the command to edit an existing user. `-d` (abbreviation for `--home`) will change the
user's home directory. Adding `-m` (abbreviation for `--move-home` will also move the content from
the user's current directory to the new directory.

```bash
yum install -y passwd sudo

myUsername=wangq
adduser -G wheel $myUsername
echo -e "[user]\ndefault=$myUsername" >> /etc/wsl.conf
echo -e "[interop]\nappendWindowsPath=false" >> /etc/wsl.conf
passwd $myUsername

```

```bash
pkill -KILL -u wangq

# Change the Home directory
mkdir -p /share/home
usermod -m -d /share/home/wangq wangq

```

### Sudo

We *must* install Homebrew as a non-sudoer.

This is *not* a necessary step.

```bash
usermod -aG wheel wangq
visudo

# wangq  ALL=(ALL) NOPASSWD:ALL

```

### Backup WSL

```powershell
wsl --terminate CentOS

wsl --export CentOS $HOME\VM\centos.root.tar

# Totally remove CentOS
# wsl --unregister CentOS

```

## CentS

We will build the VM (almost all in share/) with system gcc and yum packages, linked to the system
libc

```powershell
wsl --import CentS $HOME\VM\CentS $HOME\VM\centos.root.tar

wsl -d CentS

```

### cbp

```bash
WINDOWS_HOST=192.168.32.1
export ALL_PROXY="socks5h://${WINDOWS_HOST}:7890" HTTP_PROXY="http://${WINDOWS_HOST}:7890" HTTPS_PROXY="http://${WINDOWS_HOST}:7890" RSYNC_PROXY="${WINDOWS_HOST}:7890"

cd

# Install cbp
curl -LO https://github.com/wang-q/cbp/releases/latest/download/cbp.linux
chmod +x cbp.linux
./cbp.linux init
source ~/.bashrc
rm cbp.linux

# curl
cbp install curl
curl -k -o $(cbp prefix)/share/cacert.pem -L https://curl.se/ca/cacert-2025-02-25.pem
echo "cacert $(cbp prefix)/share/cacert.pem" > $HOME/.curlrc

# CLI tools
cbp install cmake ninja
cbp install pigz pv
cbp install sqlite3
cbp install datamash tsv-utils
cbp install jq pup
cbp install pandoc
cbp install bat dust eza fd ripgrep
cbp install hyperfine tealdeer tokei

# gnuplot and graphviz
cbp install gnuplot
gnuplot <<- EOF
    set term png
    set output "output.png"
    plot sin(x) with linespoints pointtype 3
EOF

cbp install graphviz
dot -Tpdf -o sample.pdf <(echo "digraph G { a -> b }")

# blast and sratoolkit
cbp install blast sratoolkit

# ngs
cbp install bwa samtools bcftools
cbp install picard fastqc

```

### Perl, Python, and Java

```bash
# Perl
cbp install perl5.34

curl -L https://cpanmin.us | perl - App::cpanminus

# Python
cbp install python3.11 uv

# python3 -m ensurepip --upgrade
# python3 -m pip install --upgrade pip setuptools wheel

uv pip install --system numpy matplotlib

# Java
cbp install openjdk

```

### Perl modules

```bash
# Perl
# cpanm --look XML::Parser
# perl Makefile.PL EXPATLIBPATH="$(brew --prefix expat)/lib" EXPATINCPATH="$(brew --prefix expat)/include"
# make test
# make install

# cpanm --look Net::SSLeay
# OPENSSL_PREFIX="$(cbp prefix)" perl Makefile.PL
# make
# make test
# make install

bash ~/Scripts/dotfiles/perl/install.sh

#cpanm --verbose Statistics::R

# My modules
cpanm -nq App::Dazz # need dazz in $PATH
cpanm --verbose --force App::Dazz

# App::Plotr
curl -fsSL https://raw.githubusercontent.com/wang-q/App-Plotr/master/share/check_dep.sh |
    bash

```

### spades

CMake 3.16 or higher

SPAdes requires gcc version 9.1 or later

```bash
cd

curl -LO https://github.com/Kitware/CMake/releases/download/v3.31.5/cmake-3.31.5-linux-x86_64.tar.gz
tar xvfz cmake-3*.tar.gz
mv cmake-3.31.5-linux-x86_64 ~/share/cmake
ln -sf ~/share/cmake/bin/cmake ~/bin/cmake

```

```bash
#cd
#
##curl -LO https://github.com/ablab/spades/releases/download/v4.0.0/SPAdes-4.0.0-Linux.tar.gz
#
#curl -LO https://github.com/ablab/spades/releases/download/v4.0.0/SPAdes-4.0.0.tar.gz
#
#tar xvfz SPAdes-4*.tar.gz
#cd SPAdes-4*
#
#./spades_compile.sh
#
#mv SPAdes-4.0.0-Linux ~/share/SPAdes
#
#ln -sf ~/share/SPAdes/bin/spades.py ~/bin/spades.py
#
#spades.py --test

```

### nwr

```bash
mkdir ~/.nwr

# Put the files of appropriate time into this directory
cp /mnt/c/Users/wangq/.nwr/* ~/.nwr/

```

### Backup WSL

```powershell
wsl --terminate CentS

wsl --export CentS $HOME\VM\CentS.tar

```

## CentH

Homebrew

```powershell
# wsl --unregister CentH

wsl --import CentH $HOME\VM\CentH $HOME\VM\centos.root.tar
# wsl --import CentH D:\VM\CentH D:\VM\centos.root.tar

wsl -d CentH

```

```bash
WINDOWS_HOST=192.168.32.1
export ALL_PROXY="socks5h://${WINDOWS_HOST}:7890" HTTP_PROXY="http://${WINDOWS_HOST}:7890" HTTPS_PROXY="http://${WINDOWS_HOST}:7890" RSYNC_PROXY="${WINDOWS_HOST}:7890"

ln -s /mnt/c/Users/wangq/Scripts/ Scripts

cd
mkdir homebrew &&
    curl -L https://github.com/Homebrew/brew/tarball/master |
        tar xz --strip 1 -C homebrew

eval "$($HOME/homebrew/bin/brew shellenv)"
brew update --force --quiet

if grep -q -i Homebrew $HOME/.bashrc; then
    echo "==> .bashrc already contains Homebrew"
else
    echo "==> Update .bashrc"

    echo >> $HOME/.bashrc
    echo '# Homebrew' >> $HOME/.bashrc
    echo "export HOMEBREW_NO_ANALYTICS=1" >> $HOME/.bashrc
    echo 'eval "$($HOME/homebrew/bin/brew shellenv)"' >> $HOME/.bashrc
    echo >> $HOME/.bashrc
fi

source $HOME/.bashrc

```

### gcc and commonly used libraries

* Homebrew 4.0 brings glibc-bootstrap, which makes installing glibc and gcc much easier.

```bash
export HOMEBREW_NO_AUTO_UPDATE=1

brew install glibc
brew link glibc --force

if grep -q -i BREW_GLIBC $HOME/.bashrc; then
    echo "==> .bashrc already contains BREW_GLIBC"
else
    echo "==> Update .bashrc"
    echo >> $HOME/.bashrc
    echo '# BREW_GLIBC' >> $HOME/.bashrc
    echo 'export PATH="$HOME/homebrew/opt/glibc/bin:$PATH"' >> $HOME/.bashrc
    echo 'export PATH="$HOME/homebrew/opt/glibc/sbin:$PATH"' >> $HOME/.bashrc
#    echo 'export LDFLAGS="-L$HOME/homebrew/opt/glibc/lib $LDFLAGS"' >> $HOME/.bashrc
#    echo 'export CFLAGS="-I$HOME/homebrew/opt/glibc/include $CFLAGS"' >> $HOME/.bashrc
#    echo 'export CPPFLAGS="-I$HOME/homebrew/opt/glibc/include $CPPFLAGS"' >> $HOME/.bashrc
    echo >> $HOME/.bashrc
fi
source ~/.bashrc

brew install gcc # now as gcc@14

brew install binutils
brew link binutils --force

brew test gcc

brew install perl

# Downloads
brew install parallel
echo "will cite" | parallel --citation

# https://docs.brew.sh/FAQ#can-i-edit-formulae-myself
# https://stackoverflow.com/a/75520170/23645669
# https://stackoverflow.com/a/68816241/23645669
export HOMEBREW_NO_INSTALL_FROM_API=1
export HOMEBREW_NO_AUTO_UPDATE=1
mkdir -p $HOME/homebrew/Library/Taps/homebrew/
cd $HOME/homebrew/Library/Taps/homebrew/
rm -rf homebrew-core
git clone --depth=1 https://github.com/Homebrew/homebrew-core.git

# brew tap --force --shallow homebrew/core
brew edit openssl@3
# comment out the line of `make test`
brew reinstall openssl@3 -s

brew install cmake

# python
brew install python # is now python@3.13

```

### R Packages

```bash
brew install r
brew pin r

# raster, classInt and spData need gdal
# units needs udunits2
# ranger, survminer might need a high version of gcc
# infercnv needs jags
# nloptr needs nlopt
# gert needs libgit2
#brew install gdal # gdal is huge
brew install udunits
brew install jags
brew install nlopt
brew install libgit2

cd
ln -s /mnt/c/Users/wangq/Scripts/ Scripts

parallel -j 1 -k --line-buffer '
    Rscript -e '\'' if (!requireNamespace("{}", quietly = FALSE)) { install.packages("{}", repos="http://mirrors.ustc.edu.cn/CRAN") } '\''
    ' ::: \
        Rcpp cpp11 openssl pkgconfig remotes XML xml2 usethis testthat devtools

bash ~/Scripts/dotfiles/r/install.sh

parallel -j 1 -k --line-buffer '
    Rscript -e '\'' if (!requireNamespace("{}", quietly = FALSE)) { install.packages("{}", repos="http://mirrors.ustc.edu.cn/CRAN") } '\''
    ' ::: \
        units ranger survminer nloptr \
        chron clusterGeneration conditionz \
        docopt  downloader expm fontcm  \
        gsubfn influenceR interp latticeExtra  mnormt \
        phylocomr phytools proto qlcMatrix reshape \
        shadowtext sparsesvd sqldf webshot

# fonts
Rscript -e 'library(remotes); options(repos = c(CRAN = "http://mirrors.ustc.edu.cn/CRAN")); remotes::install_version("Rttf2pt1", version = "1.3.8")'
Rscript -e '
    library(extrafont);
    options(repos = c(CRAN = "http://mirrors.ustc.edu.cn/CRAN"));
    font_import(prompt = FALSE);
    fonts();
    '

# anchr
parallel -j 1 -k --line-buffer '
    Rscript -e '\'' if (!requireNamespace("{}", quietly = FALSE)) { install.packages("{}", repos="http://mirrors.ustc.edu.cn/CRAN") } '\''
    ' ::: \
        argparse minpack.lm \
        ggplot2 scales viridis

# bmr
parallel -j 1 -k --line-buffer '
    Rscript -e '\'' if (!requireNamespace("{}", quietly = TRUE)) { install.packages("{}", repos="http://mirrors.ustc.edu.cn/CRAN") } '\''
    ' ::: \
        getopt foreach doParallel \
        extrafont ggplot2 gridExtra \
        survival survminer \
        timeROC pROC verification \
        tidyverse devtools BiocManager

# BioC packages
Rscript -e 'BiocManager::install(version = "3.20", ask = FALSE)'
parallel -j 1 -k --line-buffer '
    Rscript -e '\'' if (!requireNamespace("{}", quietly = TRUE)) { BiocManager::install("{}", version = "3.20") } '\''
    ' ::: \
        Biobase GEOquery GenomicDataCommons \
        biomaRt bsseq DSS scran scater edgeR pheatmap monocle DESeq2 clusterProfiler factoextra \
        DO.db genefilter geneplotter

# not available
# bold brranching maptools

# cellranger
parallel -j 1 -k --line-buffer '
    Rscript -e '\'' if (!requireNamespace("{}", quietly = TRUE)) { install.packages("{}", repos="http://mirrors.ustc.edu.cn/CRAN") } '\''
    ' ::: \
        Seurat dplyr tibble \
        ggplot2 pheatmap \
        ggsci ggrepel \
        viridis devtools NMF \
        tidyr clustree patchwork

parallel -j 1 -k --line-buffer '
    Rscript -e '\'' if (!requireNamespace("{}", quietly = TRUE)) { BiocManager::install("{}", version = "3.20") } '\''
    ' ::: \
        org.Hs.eg.db GSEABase biomaRt \
        DoubletFinder presto \
        monocle slingshot clusterProfiler GSVA  rtracklayer  harmony infercnv
Rscript -e 'devtools::install_github("cole-trapnell-lab/monocle3")'  #monocle3
Rscript -e 'devtools::install_github("chris-mcginnis-ucsf/DoubletFinder")' #DoubleFinder
Rscript -e 'devtools::install_github("immunogenomics/presto")' #presto

```

### Backup WSL

```powershell
wsl --terminate CentH

wsl --export CentH $HOME\VM\CentH.tar

```

## My modules

```bash
# Manually
dotfiles/genomics.sh

# egaz
curl -fsSL https://raw.githubusercontent.com/wang-q/App-Egaz/master/share/check_dep.sh |
    bash

# anchr
curl -fsSL https://raw.githubusercontent.com/wang-q/anchr/main/templates/install_dep.sh | bash

curl -fsSL https://raw.githubusercontent.com/wang-q/anchr/main/templates/check_dep.sh | bash

# leading assemblers
brew install spades
spades.py --test
rm -fr spades_test

# quast, assembly quality assessment
# https://github.com/ablab/quast/issues/140
brew install brewsci/bio/quast --HEAD
quast --test

rm -fr test_data quast_test_output

# Reinstall R modules missing from the previous steps

# can be built by gcc-4
Rscript -e 'library(remotes); options(repos = c(CRAN = "http://mirrors.ustc.edu.cn/CRAN")); remotes::install_version("ranger", version = "0.14.1")'
Rscript -e 'library(remotes); options(repos = c(CRAN = "http://mirrors.ustc.edu.cn/CRAN")); remotes::install_version("RcppTOML", version = "0.1.7")'

```

## .ssh

```bash
cp -R /mnt/c/Users/wangq/.ssh/ ~/

chmod 700 ~/.ssh
chmod 600 ~/.ssh/config
chmod 600 ~/.ssh/id_rsa
chmod 600 ~/.ssh/id_rsa.pub
chmod 600 ~/.ssh/known_hosts

```

## Mirror to remote server

```bash
export HPCC=202.119.37.253
export PORT=22

export HPCC=58.213.64.36
export PORT=8804

# ssh-copy-id

# CentS
rsync -avP -e "ssh -p ${PORT}" ~/bin/ wangq@${HPCC}:bin

rsync -avP -e "ssh -p ${PORT}" ~/share/gnuplot/ wangq@${HPCC}:share/gnuplot
rsync -avP -e "ssh -p ${PORT}" ~/share/graphviz/ wangq@${HPCC}:share/graphviz

rsync -avP -e "ssh -p ${PORT}" ~/share/Perl/ wangq@${HPCC}:share/Perl
rsync -avP -e "ssh -p ${PORT}" ~/share/Python/ wangq@${HPCC}:share/Python

rsync -avP -e "ssh -p ${PORT}" ~/share/as7env/ wangq@${HPCC}:share/as7env

rsync -avP -e "ssh -p ${PORT}" ~/.cargo/ wangq@${HPCC}:.cargo --exclude="*registry/*"
rsync -avP -e "ssh -p ${PORT}" ~/.nwr/ wangq@${HPCC}:.nwr

# CentH
rsync -avP -e "ssh -p ${PORT}" ~/homebrew/ wangq@${HPCC}:homebrew --exclude="*Taps/*"

#rsync -avP -e "ssh -p ${PORT}" ~/share/R/ wangq@${HPCC}:share/R

rsync -avP -e "ssh -p ${PORT}" ~/.bashrc wangq@${HPCC}:.bashrc
rsync -avP -e "ssh -p ${PORT}" ~/.bash_profile wangq@${HPCC}:.bash_profile

# Ubuntu
rsync -avP -e "ssh -p ${PORT}" ~/.fonts/ wangq@${HPCC}:.fonts

# Sync back
rsync -avP -e "ssh -p ${PORT}" wangq@${HPCC}:share/ ~/share
rsync -avP -e "ssh -p ${PORT}" wangq@${HPCC}:bin/ ~/bin

rsync -avP -e "ssh -p ${PORT}" wangq@${HPCC}:homebrew/ ~/homebrew
rsync -avP -e "ssh -p ${PORT}" wangq@${HPCC}:share/R/ ~/share/R

```

## Old codes

### curl

```bash
## curl need libnghttp2
## libnghttp2 is in epel
#yum install -y epel-release
#sed -e 's|^metalink=|#metalink=|g' \
#    -e 's|^#baseurl=https\?://download.fedoraproject.org/pub/epel/|baseurl=https://mirrors.ustc.edu.cn/epel/|g' \
#    -e 's|^#baseurl=https\?://download.example/pub/epel/|baseurl=https://mirrors.ustc.edu.cn/epel/|g' \
#    -i.bak \
#    /etc/yum.repos.d/epel.repo
#yum install -y libnghttp2
#
## city-fan
#rpm -Uvh https://mirror.city-fan.org/ftp/contrib/yum-repo/city-fan.org-release-3-8.rhel7.noarch.rpm
#
#yum install -y yum-utils
#
#yum --enablerepo=city-fan.org install -y libcurl libcurl-devel
#
#curl --version
## curl 8.1.2
#
#yum-config-manager --disable city-fan.org
#
## https://github.com/Linuxbrew/legacy-linuxbrew/issues/46#issuecomment-308758171
#yum remove -y yum-utils

```


### Change the hostname

Can't change hostname inside WSL

```bash
#hostnamectl set-hostname centos
#
#systemctl reboot

```
### R with system `libc`

R was built with system `gcc` and linked to the system `libc`.

Avoid using graphic, gtk and x11 packages in brew.

```bash
cd
ln -sf /mnt/c/Users/wangq/Scripts/ Scripts

# A minimal R built by gcc-4.8
bash ~/Scripts/dotfiles/r/build.sh

source $HOME/.bashrc

```

### Old R

```bash
## nloptr need `cmake`
##ln -s /usr/bin/cmake3 ~/bin/cmake
#
## brew unlink libxml2
#
## Can't use brewed libxml2
#Rscript -e ' install.packages(
#    "XML",
#    repos="http://mirrors.ustc.edu.cn/CRAN",
#    configure.args = "--with-xml-config=/usr/bin/xml2-config",
#    configure.vars = "CC=gcc"
#    ) '
#
## manually
##curl -L https://mirrors.ustc.edu.cn/CRAN/src/contrib/XML_3.99-0.18.tar.gz |
##    tar xvz
##cd XML
##./configure --with-xml-config=/usr/bin/xml2-config
##CC=gcc R CMD INSTALL . --configure-args='--with-xml-config=/usr/bin/xml2-config'
#
## export PKG_CONFIG_PATH="/usr/lib64/pkgconfig/"
## pkg-config --cflags libxml-2.0
## pkg-config --libs libxml-2.0
#Rscript -e ' install.packages(
#    "xml2",
#    repos="http://mirrors.ustc.edu.cn/CRAN",
#    configure.vars = "CC=gcc INCLUDE_DIR=/usr/include/libxml2 LIB_DIR=/usr/lib64"
#    ) '

```
