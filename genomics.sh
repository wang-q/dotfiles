#!/usr/bin/env bash

echo "====> Building Genomics related tools <===="

echo "==> Anchr"
# TODO: superreads can't find `jellyfish/circular_buffer.hpp`
#   `include/jellyfish-2.2.4/`

curl -fsSL https://raw.githubusercontent.com/wang-q/App-Anchr/master/share/install_dep.sh | bash

echo "==> Install bioinformatics softwares"
brew tap brewsci/bio
brew tap brewsci/science

brew install clustal-w mafft
#brew install --force-bottle blast
#brew install --force-bottle rmblast
brew install hmmer lastz raxml fasttree
brew install bowtie bowtie2 bwa igvtools
brew install tophat cufflinks stringtie hisat2
brew install sratoolkit
brew install genometools
brew install canu
brew install kmergenie
brew install snp-sites --build-from-source # macOS bottles broken
brew install bcftools

echo "==> Custom tap"
brew tap wang-q/tap
brew install faops multiz sparsemem intspan
brew install jrunlist jrange

echo "==> RepeatMasker"
#brew install brewsci/bio/blast@2.2
#brew link brewsci/bio/blast@2.2 --overwrite --force
brew install repeatmasker --build-from-source # run config later

echo "==> Config repeatmasker"
wget -N -P /tmp https://github.com/egateam/egavm/releases/download/20170907/repeatmaskerlibraries-20140131.tar.gz

pushd $(brew --prefix)/opt/repeatmasker/libexec
rm -fr lib/perl5/x86_64-linux-thread-multi/
rm Libraries/RepeatMasker.lib*
rm Libraries/DfamConsensus.embl
popd
pushd $(brew --prefix)/Cellar/$(brew list --versions repeatmasker | sed 's/ /\//')/libexec
tar zxvf /tmp/repeatmaskerlibraries-20140131.tar.gz
sed -i".bak" 's/\/usr\/bin\/perl/env/' configure.input
./configure < configure.input
popd

# TODO: remove these
rm $(brew --prefix)/bin/rmOutToGFF3.pl
sed -i".bak" 's/::Bin/::RealBin/' $(brew --prefix)/Cellar/$(brew list --versions repeatmasker | sed 's/ /\//')/libexec/util/rmOutToGFF3.pl
ln -s $(brew --prefix)/Cellar/$(brew list --versions repeatmasker | sed 's/ /\//')/libexec/util/rmOutToGFF3.pl $(brew --prefix)/bin/rmOutToGFF3.pl
