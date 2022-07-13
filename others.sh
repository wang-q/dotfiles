#!/usr/bin/env bash

mkdir -p $HOME/share/

echo "==> TrimGalore"
curl -LO https://raw.githubusercontent.com/FelixKrueger/TrimGalore/master/trim_galore
mv trim_galore $HOME/bin
chmod +x $HOME/bin/trim_galore

echo "==> circos-tools"
cd $HOME/share/
curl -LO http://circos.ca/distribution/circos-tools-0.22.tgz

rm -fr circos-tools
tar xvfz circos-tools-0.22.tgz
mv circos-tools-0.22 circos-tools

rm circos-tools-0.22.tgz

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

echo "==> interproscan"
mkdir -p $HOME/software/interproscan
cd $HOME/software/interproscan

proxychains4 wget -N ftp://ftp.ebi.ac.uk/pub/software/unix/iprscan/5/5.48-83.0/interproscan-5.48-83.0-64-bit.tar.gz
wget ftp://ftp.ebi.ac.uk/pub/software/unix/iprscan/5/5.48-83.0/interproscan-5.48-83.0-64-bit.tar.gz.md5

md5sum -c interproscan-5.48-83.0-64-bit.tar.gz.md5

# proxychains4 wget -N ftp://ftp.ebi.ac.uk/pub/software/unix/iprscan/5/data/panther-data-12.0.tar.gz
# wget ftp://ftp.ebi.ac.uk/pub/software/unix/iprscan/5/data/panther-data-12.0.tar.gz.md5

# md5sum -c panther-data-12.0.tar.gz.md5

# wget -N -P /tmp ftp://ftp.ebi.ac.uk/pub/software/unix/iprscan/5/lookup_service/lookup_service_5.32-71.0.tar.gz
# wget -N -P /tmp ftp://ftp.ebi.ac.uk/pub/software/unix/iprscan/5/lookup_service/lookup_service_5.32-71.0.tar.gz.md5

# md5sum -c lookup_service_5.32-71.0.tar.gz.md5

cd $HOME/share/

rm -fr interproscan

pigz -dc /$HOME/software/interproscan/interproscan-5.48-83.0-64-bit.tar.gz | pv | tar -pxv -f -
mv interproscan-5.48-83.0 interproscan

# pigz -dc /$HOME/software/interproscan/panther-data-12.0.tar.gz | pv | tar -pxv -f -
# mv panther interproscan/data

# turn off local pre-calculated match lookup service
sed -i '/precalculated.match.lookup.service.url/s/^/#/g' interproscan/interproscan.properties

ln -fs $HOME/share/interproscan/interproscan.sh $HOME/bin/interproscan.sh

# Manually download SignalP, TMHMM
# Need to accept licences
# https://services.healthtech.dtu.dk/software.php
tar -xvz -f /$HOME/software/interproscan/signalp-4.1g.Linux.tar.gz
mkdir -p interproscan/bin/signalp/4.1/
cp -R signalp-4.1/* interproscan/bin/signalp/4.1/
sed -i '/\$ENV{SIGNALP} =/c\'"\$ENV{SIGNALP} = 'bin/signalp/4.1';" interproscan/bin/signalp/4.1/signalp

tar -xvz -f /$HOME/software/interproscan/tmhmm-2.0c.Linux.tar.gz
mkdir -p interproscan/bin/tmhmm/2.0c/
cp tmhmm-2.0c/bin/decodeanhmm.Linux_x86_64 interproscan/bin/tmhmm/2.0c/decodeanhmm
mkdir -p interproscan/data/tmhmm/2.0c/
cp tmhmm-2.0c/lib/TMHMM2.0.model interproscan/data/tmhmm/2.0c/TMHMM2.0c.model

cd $HOME/share/interproscan
python3 initial_setup.py

# PPanGGOLiN
# Python 3.7
# We need the testing dataset in the source repo
parallel -j 1 -k --line-buffer '
    pip3 install \
        --trusted-host mirror.nju.edu.cn \
        -i http://mirror.nju.edu.cn/pypi/web/simple/ \
        {}
    ' ::: \
        tqdm tables networkx dataclasses \
        numpy pandas scipy plotly \
        gmpy2 colorlover bokeh

brew install prodigal
brew install brewsci/bio/aragorn
brew install brewsci/bio/infernal
brew install mmseqs2
brew install mafft

# pip3 install git+https://github.com/labgem/netsyn.git

cd $HOME/share/
rm -fr PPanGGOLiN

git clone https://github.com/labgem/PPanGGOLiN.git

cd PPanGGOLiN
python3 setup.py install

cd testingDataset
ppanggolin workflow --fasta organisms.fasta.list

ppanggolin workflow --anno organisms.gbff.list

# antismash
echo "==> antismash"

brew install openjdk
brew install blast diamond fasttree muscle hmmer
brew install brewsci/science/glimmerhmm
brew install wang-q/tap/hmmer@2 # append a 2 to all executables
brew install wang-q/tap/meme@4 # 4.11.2_2

pip3 install -i https://mirror.nju.edu.cn/pypi/web/simple/ virtualenv
# pip3 install numpy matplotlib scipy scikit-learn
# pip3 install helperlibs jinja2 joblib jsonschema markupsafe pysvg pyscss
# pip3 install biopython bcbio-gff

aria2c -c https://dl.secondarymetabolites.org/releases/6.1.1/antismash-6.1.1.tar.gz
tar xvzf antismash-*.tar.gz

virtualenv -p $(which python3) ~/share/asenv
source ~/share/asenv/bin/activate

pip3 install -i https://mirror.nju.edu.cn/pypi/web/simple/ ./antismash-6.1.1

#the site of database:~/share/asenv/lib/python3.9/site-packages/antismash/database
download-antismash-databases # 9G

antismash --check-prereqs

# Later, if you want to run antiSMASH, simply call
source ~/share/asenv/bin/activate
antismash my_input.gbk
