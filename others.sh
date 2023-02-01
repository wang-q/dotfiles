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

# https://interproscan-docs.readthedocs.io/en/latest/HowToDownload.html
echo "==> interproscan"
mkdir -p $HOME/software/interproscan
cd $HOME/software/interproscan

aria2c -x 4 -s 2 -c https://ftp.ebi.ac.uk/pub/software/unix/iprscan/5/5.60-92.0/interproscan-5.60-92.0-64-bit.tar.gz
wget https://ftp.ebi.ac.uk/pub/software/unix/iprscan/5/5.60-92.0/interproscan-5.60-92.0-64-bit.tar.gz.md5

md5sum -c interproscan-5.60-92.0-64-bit.tar.gz.md5

cd $HOME/share/

rm -fr interproscan

pigz -dc /$HOME/software/interproscan/interproscan-5.60-92.0-64-bit.tar.gz | pv | tar -pxv -f -
mv interproscan-5.60-92.0 interproscan

cd $HOME/share/interproscan
python3 setup.py interproscan.properties

# turn off local pre-calculated match lookup service
sed -i '/precalculated.match.lookup.service.url/s/^/#/g' interproscan.properties

ln -fs $HOME/share/interproscan/interproscan.sh $HOME/bin/interproscan.sh

# # Manually download SignalP, TMHMM
# # Need to accept licences
# # https://services.healthtech.dtu.dk/software.php
# tar -xvz -f /$HOME/software/interproscan/signalp-4.1g.Linux.tar.gz
# mkdir -p interproscan/bin/signalp/4.1/
# cp -R signalp-4.1/* interproscan/bin/signalp/4.1/
# sed -i '/\$ENV{SIGNALP} =/c\'"\$ENV{SIGNALP} = 'bin/signalp/4.1';" interproscan/bin/signalp/4.1/signalp

# tar -xvz -f /$HOME/software/interproscan/tmhmm-2.0c.Linux.tar.gz
# mkdir -p interproscan/bin/tmhmm/2.0c/
# cp tmhmm-2.0c/bin/decodeanhmm.Linux_x86_64 interproscan/bin/tmhmm/2.0c/decodeanhmm
# mkdir -p interproscan/data/tmhmm/2.0c/
# cp tmhmm-2.0c/lib/TMHMM2.0.model interproscan/data/tmhmm/2.0c/TMHMM2.0c.model

./interproscan.sh -i test_all_appl.fasta -f tsv -dp

# interproscan bundled rpsbproc need gcc 4.9
# bin/blast/rpsbproc: /lib64/libstdc++.so.6: version `GLIBCXX_3.4.21' not found (required by bin/blast/rpsbproc)
# https://github.com/ebi-pf-team/interproscan/issues/114
echo "==> cddblast"

mkdir -p $HOME/software/cddblast
cd $HOME/software/cddblast

aria2c -x 4 -s 2 -c https://ftp.ncbi.nih.gov/blast/executables/blast+/2.9.0/ncbi-blast-2.9.0+-src.tar.gz
wget https://ftp.ncbi.nih.gov/blast/executables/blast+/2.9.0/ncbi-blast-2.9.0+-src.tar.gz.md5

md5sum -c ncbi-blast-2.9.0+-src.tar.gz.md5

wget https://ftp.ncbi.nih.gov/pub/mmdb/cdd/rpsbproc/RpsbProc-src.tar.gz 

tar xvzf ncbi-blast-2.9.0+-src.tar.gz
tar xvzf RpsbProc-src.tar.gz

mkdir -p ncbi-blast-2.9.0+-src/c++/src/app/RpsbProc
cp -rf RpsbProc/src/* ncbi-blast-2.9.0+-src/c++/src/app/RpsbProc/

# edit Makefile.in
cat <<EOF > ncbi-blast-2.9.0+-src/c++/src/app/Makefile.in
SUB_PROJ = blast RpsbProc

EXPENDABLE_SUB_PROJ = split_cache wig2table netcache rmblastn dblb tls idfetch pubseq_gateway

REQUIRES = app

srcdir = @srcdir@
include @builddir@/Makefile.meta

EOF

cd ncbi-blast-2.9.0+-src/c++
CC=gcc-4.8 CXX=g++-4.8 ./configure
make -k -j 8

#after compilation is complete
cp ReleaseMT/bin/rpsblast $HOME/share/interproscan/bin/blast/
cp ReleaseMT/bin/rpsbproc $HOME/share/interproscan/bin/blast/

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
