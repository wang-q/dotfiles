#!/usr/bin/env bash

mkdir -p $HOME/share/

echo "==> Download mysql"
wget -N -P /tmp https://mirrors.ustc.edu.cn/mysql-ftp/Downloads/MySQL-5.1/mysql-5.1.73.tar.gz

echo "==> compile mysql"
cd $HOME/share/
rm -fr mysql-*
tar xvfz /tmp/mysql-5.1.73.tar.gz
cd mysql-*

export MYSQL_USER=`whoami`
export MYSQL_DIR=$HOME/share/mysql

if [[ `uname` == 'Darwin' ]]; then
    export CC=gcc-5
    export CXX=gcc-5
else
    export CC=gcc-5
    export CXX=gcc-5
fi

CFLAGS="-O3 -fPIC" CXXFLAGS="-O3 -fPIC -felide-constructors -fno-exceptions -fno-rtti" \
    ./configure \
    --prefix=${MYSQL_DIR} \
    --with-extra-charsets=complex \
    --enable-thread-safe-client \
    --enable-local-infile \
    --enable-shared \
    --enable-assembler \
    --without-docs \
    --without-man \
    --without-debug \
    --with-plugins=myisam \
    --disable-dependency-tracking \
    --with-mysqld-user=${MYSQL_USER} \
    --localstatedir=${MYSQL_DIR}/data \
    --sysconfdir=${MYSQL_DIR} \
    --with-unix-socket-path=${MYSQL_DIR}/mysql.sock

make -j 4
make install

mkdir -p ${MYSQL_DIR}/data

if grep -q -i mysqlbin $HOME/.bashrc; then
    echo "==> .bashrc already contains mysqlbin"
else
    echo "==> Update .bashrc"

    LB_PATH='export PATH="$HOME/share/mysql/bin:$PATH"'
    echo '# mysqlbin' >> $HOME/.bashrc
    echo ${LB_PATH} >> $HOME/.bashrc
    echo >> $HOME/.bashrc

    eval ${LB_PATH}
fi

cat <<EOF > ${MYSQL_DIR}/my.cnf
[mysqld]
user=${MYSQL_USER}
basedir=${MYSQL_DIR}
datadir=${MYSQL_DIR}/data
port=3306
socket=${MYSQL_DIR}/mysql.sock

loose-skip-innodb
skip-external-locking

character-set-server=latin1
default-storage-engine = MyISAM

key_buffer_size = 4096M
max_allowed_packet = 16M
table_open_cache = 512
sort_buffer_size = 16M
read_buffer_size = 16M
read_rnd_buffer_size = 32M
myisam_sort_buffer_size = 128M
thread_cache_size = 16
thread_concurrency = 32
query_cache_size = 128M
query_cache_limit = 8M

[mysqld_safe]
log-error=${MYSQL_DIR}/mysqld.log
pid-file=${MYSQL_DIR}/mysqld.pid
socket=${MYSQL_DIR}/mysql.sock

[client]
port=3306
user=${MYSQL_USER}
socket=${MYSQL_DIR}/mysql.sock

[mysqladmin]
user=root
port=3306
socket=${MYSQL_DIR}/mysql.sock

[mysql]
port=3306
socket=${MYSQL_DIR}/mysql.sock

[mysql_install_db]
user=${MYSQL_USER}
port=3306
basedir=${MYSQL_DIR}
datadir=${MYSQL_DIR}/data
socket=${MYSQL_DIR}/mysql.sock

[myisamchk]
key_buffer_size = 256M
sort_buffer_size = 256M
read_buffer = 16M
write_buffer = 16M

EOF

echo "==> Fill mysql system tables"
unset TMPDIR
unset MYSQL_USER
unset MYSQL_DIR

mysql_install_db

echo "==> Start mysql service"
cd $HOME/share/mysql
$HOME/share/mysql/bin/mysqld_safe &
sleep 5

echo "==> Securing mysql service"
if [ "$(whoami)" == 'vagrant' ]; then
    cat <<EOF | mysql_secure_installation

Y
vagrant
vagrant
Y
Y
Y
Y

EOF
else
    mysql_secure_installation
fi

rm -fr $HOME/share/mysql-*

# create mysql user
cat <<EOF

# copy & paste the following lines to command prompt; then type password of mysql root

source $HOME/.bashrc
mysql -uroot -p -e "GRANT ALL PRIVILEGES ON *.* TO 'alignDB'@'%' IDENTIFIED BY 'alignDB'"

# normal startup
~/share/mysql/bin/mysqld_safe &

# shutdown
~/share/mysql/bin/mysqladmin shutdown -uroot -p

# DBD::mysql
cpanm --notest DBD::mysql

# If the above command failed, use the following
cpanm --look DBD::mysql
mkdir -p /tmp/mysql-static && cp $HOME/share/mysql/lib/mysql/*.a /tmp/mysql-static
perl Makefile.PL --testuser alignDB --testpassword alignDB --cflags="-I${HOME}/share/mysql/include/mysql -fPIC -DUNIV_LINUX -DUNIV_LINUX" --libs="-L/tmp/mysql-static -lmysqlclient -lz -lcrypt -lnsl -lm"
make test
make install

EOF
