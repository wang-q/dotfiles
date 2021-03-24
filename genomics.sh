#!/usr/bin/env bash

echo "====> Building Genomics related tools <===="

echo "==> Anchr"
# TODO: superreads can't find `jellyfish/circular_buffer.hpp`
#   `include/jellyfish-2.2.4/`

#curl -fsSL https://raw.githubusercontent.com/wang-q/App-Anchr/master/share/install_dep.sh | bash

echo "==> Install bioinformatics softwares"
brew tap brewsci/bio
brew tap brewsci/science

brew install clustal-w mafft
brew install lastz raxml fasttree
brew install bowtie bowtie2 bwa igvtools
brew install tophat cufflinks stringtie hisat2
brew install sratoolkit
brew install genometools
brew install canu
brew install snp-sites --build-from-source # macOS bottles broken
brew install bcftools

echo "==> Custom tap"
brew tap wang-q/tap
brew install faops multiz sparsemem intspan
brew install jrunlist jrange

echo "==> circos"
brew install wang-q/tap/circos@0.69.9

echo "==> RepeatMasker"
brew install blast
brew unlink blast
brew install hmmer easel

brew install wang-q/tap/rmblast@2.10.0

# https://stackoverflow.com/questions/57629010/linuxbrew-curl-certificate-issue
export HOMEBREW_CURLRC=1
echo "--ciphers DEFAULT@SECLEVEL=1" >> $HOME/.curlrc
brew install brewsci/bio/trf

brew install wang-q/tap/repeatmasker@4.1.1

# Config repeatmasker
pip3 install -i https://pypi.tuna.tsinghua.edu.cn/simple h5py

cd $(brew --prefix)/Cellar/repeatmasker@4.1.1/4.1.1/libexec
perl configure \
    -hmmer_dir=$(brew --prefix)/bin \
    -rmblast_dir=$(brew --prefix)/bin \
    -libdir=$(brew --prefix)/Cellar/repeatmasker@4.1.1/4.1.1/libexec/Libraries \
    -trf_prgm=$(brew --prefix)/bin/trf \
    -default_search_engine=rmblast

#echo "==> Config repeatmasker"
#wget -N -P /tmp https://github.com/egateam/egavm/releases/download/20170907/repeatmaskerlibraries-20140131.tar.gz
#
#pushd $(brew --prefix)/opt/repeatmasker/libexec
#rm -fr lib/perl5/x86_64-linux-thread-multi/
#rm Libraries/RepeatMasker.lib*
#rm Libraries/DfamConsensus.embl
#tar zxvf /tmp/repeatmaskerlibraries-20140131.tar.gz
#sed -i".bak" 's/\/usr\/bin\/perl/env/' configure.input
#./configure < configure.input
#popd
