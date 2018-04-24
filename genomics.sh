#!/usr/bin/env bash

mkdir -p $HOME/share/

echo "====> Building Genomics related tools <===="

echo "==> anchr"
curl -fsSL https://raw.githubusercontent.com/wang-q/App-Anchr/master/share/install_dep.sh | bash

echo "==> other tools"
brew tap brewsci/bio
brew tap brewsci/science

brew install mafft
brew install bowtie bowtie2 igvtools
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

echo "==> circos"
cd /prepare/resource/
wget -N http://circos.ca/distribution/circos-0.69-6.tgz
wget -N http://circos.ca/distribution/circos-tools-0.22.tgz

cd $HOME/share/
rm -fr circos
tar xvfz /prepare/resource/circos-0.69-6.tgz
mv circos-0.69-6 circos

perl -pi -e 's{^#!\/bin\/env}{#!\/usr\/bin\/env}g' $HOME/share/circos/bin/circos
perl -pi -e 's{^#!\/bin\/env}{#!\/usr\/bin\/env}g' $HOME/share/circos/bin/gddiag

ln -fs $HOME/share/circos/bin/circos $HOME/bin/circos

cd $HOME/share/
rm -fr circos-tools
tar xvfz /prepare/resource/circos-tools-0.22.tgz
mv circos-tools-0.22 circos-tools

echo "==> clone or pull"
mkdir -p $HOME/Scripts/

for OP in dotfiles alignDB withncbi; do
    if [ ! -d "$HOME/Scripts/$OP/.git" ]; then
        if [ ! -d "$HOME/Scripts/$OP" ]; then
            echo "==> Clone $OP"
            git clone https://github.com/wang-q/$OP.git "$HOME/Scripts/$OP"
        else
            echo "==> $OP exists"
        fi
    else
        echo "==> Pull $OP"
        cd "$HOME/Scripts/$OP"
        git pull
    fi
done

chmod +x $HOME/Scripts/alignDB/alignDB.pl
ln -fs $HOME/Scripts/alignDB/alignDB.pl $HOME/bin/alignDB.pl
