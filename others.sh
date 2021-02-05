#!/usr/bin/env bash

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
