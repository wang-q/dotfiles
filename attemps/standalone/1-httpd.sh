#!/usr/bin/env bash

mkdir -p $HOME/share/

echo "====> Building Apache httpd <===="

echo "==> download"
cd /prepare/resource/
wget -N http://mirrors.ustc.edu.cn/apache/httpd/httpd-2.4.16.tar.gz
wget -N http://mirrors.ustc.edu.cn/apache/apr/apr-1.5.2.tar.gz
wget -N http://mirrors.ustc.edu.cn/apache/apr/apr-util-1.5.4.tar.gz

echo "==> untar"
cd $HOME/share/
tar xvfz /prepare/resource/httpd-2.*.tar.gz
tar xvfz /prepare/resource/apr-1.*.tar.gz
tar xvfz /prepare/resource/apr-util-1.*.tar.gz

mv apr-1* apr
mv apr-util-1* apr-util
mv apr httpd-2.*/srclib/
mv apr-util httpd-2.*/srclib/

echo "==> compiling"
cd $HOME/share/httpd-2.*
./configure \
    --enable-file-cache \
    --enable-cache \
    --enable-disk-cache \
    --enable-mem-cache \
    --enable-deflate \
    --enable-expires \
    --enable-headers \
    --enable-usertrack \
    --enable-cgi \
    --enable-vhost-alias \
    --enable-rewrite \
    --enable-so \
    --with-included-apr \
    --with-pcre=/usr \
    --prefix=${HOME}/share/httpd
make -j 4
make install

# /usr/bin/pcre-config --prefix
# ldd $HOME/share/httpd/bin/httpd | grep pcre

echo "==> Modify httpd.conf"
cd $HOME/share/httpd
if [ ! -e conf/httpd.conf.bak ]
then
    cp conf/httpd.conf conf/httpd.conf.bak
fi
sed -i 's/Listen 80$/Listen 8088/' conf/httpd.conf
sed -i 's/#LoadModule cgid_module/LoadModule cgid_module/' conf/httpd.conf
sed -i 's/#LoadModule cgi_module/LoadModule cgi_module/' conf/httpd.conf
sed -i 's/#AddHandler cgi-script/AddHandler cgi-script/' conf/httpd.conf
sed -i 's/#ServerName www.example.com:80/ServerName 127.0.0.1/' conf/httpd.conf

cd $HOME/share/
rm -fr httpd-2.*

echo "==> test cgi"
chmod 0755 $HOME/share/httpd/cgi-bin/printenv
sed -i 's/^#$/#!\/usr\/bin\/perl/' $HOME/share/httpd/cgi-bin/printenv

$HOME/share/httpd/bin/apachectl restart
curl localhost:8088/cgi-bin/printenv
$HOME/share/httpd/bin/apachectl stop

