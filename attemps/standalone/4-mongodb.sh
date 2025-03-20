#!/usr/bin/env bash

mkdir -p $HOME/share/

echo "====> Install MongoDB <===="

mkdir -p $HOME/share/mongodb

if [[ `uname` == 'Darwin' ]]; then
    echo "==> download"
    cd /prepare/resource/
    wget -N https://fastdl.mongodb.org/osx/mongodb-osx-ssl-x86_64-4.0.10.tgz

    echo "==> untar"
    cd $HOME/share/
    tar xvfz /prepare/resource/mongodb-osx-ssl-x86_64-4.0.10.tgz
    cp -R -n mongodb-osx*/ mongodb

    rm -fr mongodb-osx*/
else
    echo "==> download"
    cd /prepare/resource/
    wget -N https://fastdl.mongodb.org/linux/mongodb-linux-x86_64-ubuntu1404-4.0.9.tgz

    echo "==> untar"
    cd $HOME/share/
    tar xvfz /prepare/resource/mongodb-linux-x86_64-ubuntu1404-4.0.9.tgz
    cp -R -n mongodb-linux*/bin mongodb

    rm -fr mongodb-linux*/
fi

mkdir -p $HOME/share/mongodb/log
mkdir -p $HOME/share/mongodb/data

echo "==> cnf file"
cat <<EOF > $HOME/share/mongodb/mongod.cnf
systemLog:
    destination: file
    path: $HOME/share/mongodb/log/mongod.log
    logAppend: true
storage:
    dbPath: $HOME/share/mongodb/data
    directoryPerDB: true
    engine: wiredTiger
    journal:
        enabled: false
net:
    bindIp: 127.0.0.1
    port: 27017

EOF

if grep -q -i mongodbbin $HOME/.bashrc; then
    echo "==> .bashrc already contains mongodbbin"
else
    echo "==> Update .bashrc"

    LB_PATH='export PATH="$HOME/share/mongodb/bin:$PATH"'
    echo '# mongodbbin' >> $HOME/.bashrc
    echo $LB_PATH >> $HOME/.bashrc
    echo >> $HOME/.bashrc

    eval $LB_PATH
fi

echo "==> done"

cat <<EOF

# Start mongodb by running

numactl --interleave=all ~/share/mongodb/bin/mongod --config ~/share/mongodb/mongod.cnf

EOF
