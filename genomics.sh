#!/usr/bin/env bash

# TODO: superreads can't find `jellyfish/circular_buffer.hpp`
#   `include/jellyfish-2.2.4/`

echo "==> Genomics related tools"
cbp install clustalo mafft muscle spoa trimal # alignments
cbp install lastz multiz mummer # genomes
cbp install diamond
cbp install faops seqtk
cbp install fasttree iqtree2 raxml-ng phylip newick-utils # phylogeny trees
cbp install aster paml consel # evolution
cbp install fastqc sickle # fastq
cbp install bwa bowtie2 # short reads mapping
cbp install picard samtools bedtools # bam
cbp install bcftools freebayes snp-sites # vcf
cbp install bcalm bifrost # unitigs
cbp install stringtie # rna-seq
cbp install prodigal # gene prediction
cbp install mash # ANI
cbp install hmmer easel hmmer2 # domains
cbp install mmseqs # clustering
cbp install trf # repeats
cbp install minimap2 miniprot # Heng Li
cbp install dazzdb daligner merquryfk fastga fastk # thegenemyers
cbp install blast sratoolkit # ncbi

cbp install intspan

# uv
uv pip install --system quast

# brew
brew tap brewsci/bio

brew install fastani
brew install hisat2 bbtools
brew install genometools

# less used
brew install augustus prokka
brew install spades
brew install canu
brew install ntcard
brew install gatk

echo "==> circos"
brew install wang-q/tap/circos@0.69.9

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
