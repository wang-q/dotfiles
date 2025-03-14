#!/usr/bin/env bash

# TODO: superreads can't find `jellyfish/circular_buffer.hpp`
#   `include/jellyfish-2.2.4/`

#curl -fsSL https://raw.githubusercontent.com/wang-q/App-Anchr/master/share/install_dep.sh | bash

echo "====> Genomics related tools <===="
cbp install clustalo muscle spoa trimal # alignments
cbp install lastz mummer # genomes
cbp install diamond
cbp install fasttree iqtree2 raxml-ng phylip newick-utils # phylogeny trees
cbp install aster paml consel # evolution
cbp install fastqc sickle # fastq
cbp install bwa bowtie2 # short reads mapping
cbp install picard samtools # bam
cbp install bcftools freebayes # vcf
cbp install bcalm bifrost # unitigs
cbp install minimap2 miniprot # Heng Li
cbp install mash # ANI
cbp install hmmer hmmer2 # domains
cbp install mmseqs # clustering
cbp install trf # repeats
cbp install dazzdb daligner merquryfk fastga fastk # thegenemyers
cbp install blast sratoolkit # ncbi

cbp install faops multiz
cbp install intspan

brew tap brewsci/bio

brew install mafft
brew install fastani
brew install stringtie hisat2 # tophat cufflinks
brew install seqtk # gfatools
brew install genometools # igvtools
brew install --build-from-source snp-sites # macOS bottles broken

brew install edirect

# less used
brew install augustus prodigal prokka
brew install spades sga
brew install canu
brew install quast --HEAD
brew install ntcard
brew install gatk

echo "==> circos"
brew install wang-q/tap/circos@0.69.9

echo "==> RepeatMasker"
brew install easel

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
