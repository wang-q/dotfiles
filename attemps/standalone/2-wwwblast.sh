#!/usr/bin/env bash

echo "====> NCBI wwwblast <===="

mkdir -p $HOME/share/blast/db/

echo "==> conf files"
if [ ! -e $HOME/share/httpd/conf/httpd.conf ]
then
    echo "Can't find httpd, exit."
    exit
else
    echo "Find httpd, continue."
fi

if grep -q -i blastdb $HOME/.bashrc; then
    echo "==> .bashrc already contains blastdb"
else
    echo "==> Updating .bashrc with blastdb..."

    BLASTDB_PATH='export BLASTDB="$HOME/share/blast/db/"'
    echo ${BLASTDB_PATH} >> $HOME/.bashrc

    eval ${BLASTDB_PATH}
fi

cat <<EOF > $HOME/.ncbirc
[NCBI]
Data=$HOME/share/blast/data/

[BLAST]
BLASTDB=$HOME/share/blast/db/

EOF

if grep -q -i wwwblast $HOME/share/httpd/conf/httpd.conf; then
    echo "==> httpd.conf already contains wwwblast"
else
    echo "==> Updating httpd.conf with wwwblast..."

    cat <<EOF >> $HOME/share/httpd/conf/httpd.conf

# wwwblast
<Directory "$HOME/share/httpd/htdocs/blast">
    Options +ExecCGI
    AllowOverride None
    Allow from all
    Order allow,deny
</Directory>

EOF
fi

echo "==> untar"
cd /prepare/resource/
wget -N http://ftp.ncbi.nlm.nih.gov/blast/executables/release/LATEST/wwwblast-2.2.26-x64-linux.tar.gz

cd $HOME/share/httpd/htdocs/
cp /prepare/resource/wwwblast*.tar.gz .

gzip -d wwwblast*.tar.gz
tar -xvpf wwwblast*.tar
rm wwwblast*.tar

chmod 777 blast/TmpGifs
chmod 666 blast/wwwblast.log
chmod 666 blast/psiblast.log


#cd $HOME/share/httpd/htdocs/blast
#mv db db.orig
#ln -s ${BLASTDB} $HOME/share/httpd/htdocs/blast/db
#perl config_setup.pl $BLASTDB out
#mv out/*.rc .
## add nr (combine of nr.00 .. nr.07); nt (nt.00 .. nt.12) to blast.rc

