#!/usr/bin/env bash

mkdir -p $HOME/share/

echo "====> Building Genomics related tools <===="

echo "==> python"
brew install python
pip install --upgrade pip
pip install --upgrade setuptools

echo "==> other tools"
brew install cmake
brew install samtools bamtools htslib bowtie bowtie2
brew install tophat cufflinks
brew install sratoolkit fastqc sickle
brew install bedtools bedops genometools
brew install stringtie hisat2 canu kmergenie

echo "==> custom tap"
brew tap wang-q/tap
brew install scythe

echo "==> trinity"
#brew install trinity
cd /prepare/resource/
wget -N https://github.com/trinityrnaseq/trinityrnaseq/archive/v2.0.6.tar.gz

cd $HOME/share/
tar xvfz /prepare/resource/v2.0.6.tar.gz

cd $HOME/share/trinityrnaseq-*
make
make plugins

echo "==> gatk"
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

echo "==> picard"
cd /prepare/resource/
wget -N https://github.com/broadinstitute/picard/releases/download/1.128/picard-tools-1.128.zip

cd $HOME/share/
unzip /prepare/resource/picard-tools-1.128.zip

java -jar picard-tools-1.128/picard.jar -h
