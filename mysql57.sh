#!/usr/bin/env bash

echo "==> Install Mysql@5.7"
brew install mysql@5.7
brew link mysql@5.7 --force

echo "==> Start mysql service"
mysqld_safe &
sleep 5

echo "==> Adjust mysql"
mysql -uroot -e "GRANT ALL PRIVILEGES ON *.* TO 'alignDB'@'%' IDENTIFIED BY 'alignDB'"
mysql -uroot -e "SET GLOBAL sql_mode=(SELECT REPLACE(@@sql_mode,'ONLY_FULL_GROUP_BY',''))"

cat <<EOF

# normal startup
mysqld_safe &

# shutdown
mysqladmin shutdown -uroot

# DBD::mysql
cpanm -v --mirror-only --mirror http://mirrors.ustc.edu.cn/CPAN/ --installdeps DBD::mysql
cpanm -v --mirror-only --mirror http://mirrors.ustc.edu.cn/CPAN/ --notest DBD::mysql

# If the above command failed, use the following
cpanm --mirror-only --mirror http://mirrors.ustc.edu.cn/CPAN/ --look DBD::mysql
mkdir -p /tmp/mysql-static && cp $(brew --prefix)/opt/mysql@5.7/lib/*.a /tmp/mysql-static
perl Makefile.PL \
  --testuser alignDB \
  --testpassword alignDB \
  --cflags="-I$(brew --prefix)/opt/mysql@5.7/include/mysql -fPIC -DUNIV_LINUX -DUNIV_LINUX" \
  --libs="-L/tmp/mysql-static -lmysqlclient -lz -lm"
make test
make install

EOF
