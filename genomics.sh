#!/usr/bin/env bash

mkdir -p $HOME/share/

echo "====> Building Genomics related tools <===="

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
cd /prepare/resource/
wget -N https://github.com/trinityrnaseq/trinityrnaseq/archive/Trinity-v2.6.6.tar.gz

cd $HOME/share/
tar xvfz /prepare/resource/Trinity-v2.6.6.tar.gz

cd $HOME/share/trinityrnaseq-Trinity-v2.6.6
make
make plugins

sed -i".bak" 's/::Bin/::RealBin/' $HOME/share/trinityrnaseq-Trinity-v2.6.6/Trinity
ln -fs $HOME/share/trinityrnaseq-Trinity-v2.6.6/Trinity $HOME/bin/Trinity

echo "==> gatk 3.5"
# brew install maven

if [[ ! -e /prepare/resource/gatk-3.5.tar.gz ]];
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

echo "==> interproscan"
cd /prepare/resource/

wget -N ftp://ftp.ebi.ac.uk/pub/software/unix/iprscan/5/5.32-71.0/interproscan-5.32-71.0-64-bit.tar.gz
wget -N ftp://ftp.ebi.ac.uk/pub/software/unix/iprscan/5/5.32-71.0/interproscan-5.32-71.0-64-bit.tar.gz.md5

md5sum -c interproscan-5.32-71.0-64-bit.tar.gz.md5

wget ftp://ftp.ebi.ac.uk/pub/software/unix/iprscan/5/data/panther-data-12.0.tar.gz
wget ftp://ftp.ebi.ac.uk/pub/software/unix/iprscan/5/data/panther-data-12.0.tar.gz.md5

md5sum -c panther-data-12.0.tar.gz.md5

# wget ftp://ftp.ebi.ac.uk/pub/software/unix/iprscan/5/lookup_service/lookup_service_5.32-71.0.tar.gz
# wget ftp://ftp.ebi.ac.uk/pub/software/unix/iprscan/5/lookup_service/lookup_service_5.32-71.0.tar.gz.md5

# md5sum -c lookup_service_5.32-71.0.tar.gz.md5

cd $HOME/share/

rm -fr interproscan

pigz -dc /prepare/resource/interproscan-5.32-71.0-64-bit.tar.gz | pv | tar -pxv -f -
pigz -dc /prepare/resource/panther-data-12.0.tar.gz | pv | tar -pxv -f -

mv interproscan-5.32-71.0 interproscan
mv panther interproscan/data

# turn off local pre-calculated match lookup service
sed -i '/precalculated.match.lookup.service.url/s/^/#/g' interproscan/interproscan.properties

ln -fs $HOME/share/interproscan/interproscan.sh $HOME/bin/interproscan.sh

# Manually download SignalP, TMHMM
tar -xvz -f /prepare/resource/signalp-4.1f.Linux.tar.gz
mkdir -p interproscan/bin/signalp/4.1/
cp -R signalp-4.1/* interproscan/bin/signalp/4.1/
sed -i '/\$ENV{SIGNALP} =/c\'"\$ENV{SIGNALP} = 'bin/signalp/4.1';" interproscan/bin/signalp/4.1/signalp

tar -xvz -f /prepare/resource/tmhmm-2.0c.Linux.tar.gz
mkdir -p interproscan/bin/tmhmm/2.0c/
cp tmhmm-2.0c/bin/decodeanhmm.Linux_x86_64 interproscan/bin/tmhmm/2.0c/decodeanhmm
mkdir -p interproscan/data/tmhmm/2.0c/
cp tmhmm-2.0c/lib/TMHMM2.0.model interproscan/data/tmhmm/2.0c/TMHMM2.0c.model

echo "==> clone or pull"
mkdir -p $HOME/Scripts/

for OP in dotfiles alignDB withncbi; do
    if [[ ! -d "$HOME/Scripts/$OP/.git" ]]; then
        if [[ ! -d "$HOME/Scripts/$OP" ]]; then
            echo "==> Clone $OP"
            git clone https://github.com/wang-q/${OP}.git "$HOME/Scripts/$OP"
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
