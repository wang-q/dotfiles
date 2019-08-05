#!/usr/bin/env bash

echo "====> Building Genomics related tools <===="

mkdir -p $HOME/bin
mkdir -p $HOME/share

echo "==> anchr"
curl -fsSL https://raw.githubusercontent.com/wang-q/App-Anchr/master/share/install_dep.sh | bash

echo "==> other tools"
brew tap brewsci/bio
brew tap brewsci/science

brew install mafft
brew install bowtie bowtie2 bwa igvtools
brew install tophat cufflinks stringtie hisat2
brew install sratoolkit
brew install genometools --without-pangocairo
brew install canu
brew install kmergenie --with-maxkmer=200
brew install snp-sites --build-from-source # macOS bottles broken
brew install bcftools

echo "==> custom tap"
brew tap wang-q/tap
brew install multiz faops

mkdir -p $HOME/share/

echo "==> trinity 2.6.6"
brew install salmon

#brew install trinity
wget -N -P /tmp https://github.com/trinityrnaseq/trinityrnaseq/archive/Trinity-v2.6.6.tar.gz

cd $HOME/share/
tar xvfz /tmp/Trinity-v2.6.6.tar.gz

cd $HOME/share/trinityrnaseq-Trinity-v2.6.6
make
make plugins

sed -i".bak" 's/::Bin/::RealBin/' $HOME/share/trinityrnaseq-Trinity-v2.6.6/Trinity
ln -fs $HOME/share/trinityrnaseq-Trinity-v2.6.6/Trinity $HOME/bin/Trinity

echo "==> gatk 3.5"
# brew install maven

if [[ ! -e /tmp/gatk-3.5.tar.gz ]]; then
    wget -N -P /tmp https://github.com/broadgsa/gatk-protected/archive/3.5.tar.gz

    cd $HOME/share/
    tar xvfz /tmp/3.5.tar.gz

    cd $HOME/share/gatk-protected-*
    # Compile the GATK but not Queue
    mvn verify -P\!queue
    mv target/executable $HOME/share/gatk

    cd $HOME/share
    tar cvfz gatk-3.5.tar.gz gatk
    mv gatk-3.5.tar.gz /tmp/
else
    cd $HOME/share/
    tar xvfz /tmp/gatk-3.5.tar.gz
fi

cd $HOME/share/
java -jar java -jar gatk/GenomeAnalysisTK.jar --help


echo "==> interproscan"
cd /tmp/

wget -N -P /tmp ftp://ftp.ebi.ac.uk/pub/software/unix/iprscan/5/5.32-71.0/interproscan-5.32-71.0-64-bit.tar.gz
wget -N -P /tmp ftp://ftp.ebi.ac.uk/pub/software/unix/iprscan/5/5.32-71.0/interproscan-5.32-71.0-64-bit.tar.gz.md5

# md5sum -c interproscan-5.32-71.0-64-bit.tar.gz.md5

wget -P /tmp ftp://ftp.ebi.ac.uk/pub/software/unix/iprscan/5/data/panther-data-12.0.tar.gz
wget -P /tmp ftp://ftp.ebi.ac.uk/pub/software/unix/iprscan/5/data/panther-data-12.0.tar.gz.md5

md5sum -c panther-data-12.0.tar.gz.md5

# wget -N -P /tmp ftp://ftp.ebi.ac.uk/pub/software/unix/iprscan/5/lookup_service/lookup_service_5.32-71.0.tar.gz
# wget -N -P /tmp ftp://ftp.ebi.ac.uk/pub/software/unix/iprscan/5/lookup_service/lookup_service_5.32-71.0.tar.gz.md5

# md5sum -c lookup_service_5.32-71.0.tar.gz.md5

cd $HOME/share/

rm -fr interproscan

pigz -dc /tmp/interproscan-5.32-71.0-64-bit.tar.gz | pv | tar -pxv -f -
pigz -dc /tmp/panther-data-12.0.tar.gz | pv | tar -pxv -f -

mv interproscan-5.32-71.0 interproscan
mv panther interproscan/data

# turn off local pre-calculated match lookup service
sed -i '/precalculated.match.lookup.service.url/s/^/#/g' interproscan/interproscan.properties

ln -fs $HOME/share/interproscan/interproscan.sh $HOME/bin/interproscan.sh

# Manually download SignalP, TMHMM
tar -xvz -f /tmp/signalp-4.1f.Linux.tar.gz
mkdir -p interproscan/bin/signalp/4.1/
cp -R signalp-4.1/* interproscan/bin/signalp/4.1/
sed -i '/\$ENV{SIGNALP} =/c\'"\$ENV{SIGNALP} = 'bin/signalp/4.1';" interproscan/bin/signalp/4.1/signalp

tar -xvz -f /tmp/tmhmm-2.0c.Linux.tar.gz
mkdir -p interproscan/bin/tmhmm/2.0c/
cp tmhmm-2.0c/bin/decodeanhmm.Linux_x86_64 interproscan/bin/tmhmm/2.0c/decodeanhmm
mkdir -p interproscan/data/tmhmm/2.0c/
cp tmhmm-2.0c/lib/TMHMM2.0.model interproscan/data/tmhmm/2.0c/TMHMM2.0c.model
