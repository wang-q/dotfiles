#!/usr/bin/env bash

mkdir -p $HOME/share/

echo "====> Building Genomics related tools <===="

echo "==> anchr"
curl -fsSL https://raw.githubusercontent.com/wang-q/App-Anchr/master/share/install_dep.sh | bash

echo "==> other tools"
brew tap brewsci/bio
brew install htslib bowtie bowtie2 igvtools
brew install tophat cufflinks stringtie hisat2
brew install sratoolkit
brew install genometools --without-pangocairo
brew install canu
brew install kmergenie --with-maxkmer=200

echo "==> custom tap"
brew tap wang-q/tap
brew install multiz faops

echo "==> trinity 2.0.6"
#brew install trinity
cd /prepare/resource/
wget -N https://github.com/trinityrnaseq/trinityrnaseq/archive/v2.0.6.tar.gz

cd $HOME/share/
tar xvfz /prepare/resource/v2.0.6.tar.gz

cd $HOME/share/trinityrnaseq-*
make
make plugins

echo "==> gatk 3.5"
# brew install maven

if [ ! -e /prepare/resource/gatk-3.5.tar.gz ];
then
    cd /prepare/resource/
    wget -N https://github.com/broadgsa/gatk-protected/archive/3.5.tar.gz

    cd $HOME/share/
    tar xvfz /prepare/resource/3.5.tar.gz

    cd $HOME/share/gatk-protected-*
    # Compile the GATK but not Queue
    mvn verify -P\!queue
    mv target/executable $HOME/share/gatk

    cd $HOME/share
    tar cvfz gatk-3.5.tar.gz gatk
    mv gatk-3.5.tar.gz /prepare/resource/
else
    cd $HOME/share/
    tar xvfz /prepare/resource/gatk-3.5.tar.gz
fi

cd $HOME/share/
java -jar java -jar gatk/GenomeAnalysisTK.jar --help
