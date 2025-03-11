#!/usr/bin/env bash

# TODO: superreads can't find `jellyfish/circular_buffer.hpp`
#   `include/jellyfish-2.2.4/`

#curl -fsSL https://raw.githubusercontent.com/wang-q/App-Anchr/master/share/install_dep.sh | bash

echo "====> Genomics related tools <===="
cbp install clustalo muscle spoa trimal # alignments
cbp install lastz mummer # genomes
cbp install diamond
cbp install iqtree2 raxml-ng phylip newick-utils # phylogeny
cbp install aster paml consel # evolution
cbp install sickle # short reads trimming
cbp install bwa # short reads mapping
cbp install bcalm bifrost # unitigs
cbp install minimap2 miniprot # Heng Li
cbp install mash # ANI
cbp install hmmer hmmer2 # domains
cbp install mmseqs # clustering
cbp install trf # repeats
cbp install dazzdb daligner merquryfk fastga fastk # thegenemyers
cbp install fastqc picard # java
cbp install blast sratoolkit # ncbi

cbp install faops multiz
cbp install intspan

brew tap brewsci/bio

brew install mafft
brew install fasttree
brew install fastani
brew install bowtie bowtie2
brew install samtools
brew install stringtie hisat2 # tophat cufflinks
brew install seqtk # gfatools
brew install genometools # igvtools
brew install --build-from-source snp-sites # macOS bottles broken
brew install bcftools

brew install edirect

# less used
brew install augustus prodigal prokka
brew install spades sga
brew install canu
brew install quast --HEAD
brew install ntcard
brew install gatk freebayes

echo "==> Custom tap"
brew tap wang-q/tap

echo "==> circos"
brew install wang-q/tap/circos@0.69.9

echo "==> RepeatMasker"
brew install hmmer easel

brew install wang-q/tap/rmblast@2.14.1
# brew link rmblast@2.14.1 --overwrite

brew install wang-q/tap/trf@4

brew install wang-q/tap/repeatmasker@4.1.1

# Config repeatmasker
pip3 install h5py

cd $(brew --prefix)/Cellar/repeatmasker@4.1.1/4.1.1/libexec
perl configure \
    -hmmer_dir=$(brew --prefix)/bin \
    -rmblast_dir=$(brew --prefix)/Cellar/rmblast@2.14.1/2.14.1/bin \
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
