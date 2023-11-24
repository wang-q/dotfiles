#!/usr/bin/env bash

echo "====> Building Genomics related tools <===="

echo "==> Anchr"
# TODO: superreads can't find `jellyfish/circular_buffer.hpp`
#   `include/jellyfish-2.2.4/`

#curl -fsSL https://raw.githubusercontent.com/wang-q/App-Anchr/master/share/install_dep.sh | bash

echo "==> Install bioinformatics softwares"
brew tap brewsci/bio
brew tap brewsci/science

brew install clustal-w mafft muscle trimal
brew install lastz diamond paml fasttree iqtree # raxml
brew install fastani mash
brew install raxml --without-open-mpi
brew install --force-bottle newick-utils
brew install fastqc # kat
brew install bowtie bowtie2 bwa
brew install samtools picard-tools
brew install stringtie hisat2 # tophat cufflinks
brew install seqtk minimap2 minigraph # gfatools
brew install genometools # igvtools
brew install --build-from-source snp-sites # macOS bottles broken
brew install bcftools

brew install edirect
brew install sratoolkit

# less used
brew install augustus prodigal prokka
brew install megahit spades sga
brew install canu
brew install quast --HEAD
brew install ntcard
brew install gatk freebayes

# brew unlink proj
brew install --force-bottle blast

echo "==> Custom tap"
brew tap wang-q/tap
brew install faops multiz sparsemem intspan
# brew install multiz --cc=gcc
# brew install jrunlist jrange

echo "==> circos"
brew install wang-q/tap/circos@0.69.9

echo "==> RepeatMasker"
brew install hmmer easel

brew install wang-q/tap/rmblast@2.10.0
# brew link rmblast@2.10.0 --overwrite

brew install wang-q/tap/trf@4

brew install wang-q/tap/repeatmasker@4.1.1

# Config repeatmasker
pip3 install h5py

cd $(brew --prefix)/Cellar/repeatmasker@4.1.1/4.1.1/libexec
perl configure \
    -hmmer_dir=$(brew --prefix)/bin \
    -rmblast_dir=$(brew --prefix)/Cellar/rmblast@2.10.0/2.10.0/bin \
    -libdir=$(brew --prefix)/Cellar/repeatmasker@4.1.1/4.1.1/libexec/Libraries \
    -trf_prgm=$(brew --prefix)/bin/trf \
    -default_search_engine=rmblast

cd -

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
