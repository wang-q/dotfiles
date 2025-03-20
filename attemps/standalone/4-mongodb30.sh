#!/usr/bin/env bash

mkdir -p $HOME/share/

echo "====> Install MongoDB <===="

mkdir -p $HOME/share/mongodb30

if [[ `uname` == 'Darwin' ]];
then
    echo "==> download"
    cd /prepare/resource/
    wget -N http://fastdl.mongodb.org/osx/mongodb-osx-x86_64-3.0.14.tgz

    echo "==> untar"
    cd $HOME/share/
    tar xvfz /prepare/resource/mongodb-osx-x86_64-3.0.14.tgz
    cp -R -n mongodb-osx*/ mongodb30

    rm -fr mongodb-osx*/
else
    echo "==> download"
    cd /prepare/resource/
    wget -N http://fastdl.mongodb.org/linux/mongodb-linux-x86_64-ubuntu1404-3.0.14.tgz

    echo "==> untar"
    cd $HOME/share/
    tar xvfz /prepare/resource/mongodb-linux-x86_64-ubuntu1404-3.0.14.tgz
    cp -R -n mongodb-linux*/bin mongodb30

    rm -fr mongodb-linux*/
fi

mkdir -p $HOME/share/mongodb30/log
mkdir -p $HOME/share/mongodb30/data

echo "==> cnf file"
cat <<EOF > $HOME/share/mongodb30/mongod.cnf
systemLog:
    destination: file
    path: $HOME/share/mongodb30/log/mongod.log
    logAppend: true
storage:
    dbPath: $HOME/share/mongodb30/data
    directoryPerDB: true
    engine: wiredTiger
    journal:
        enabled: false
net:
    bindIp: 127.0.0.1
    port: 27017
    http:
        enabled: true
        RESTInterfaceEnabled: true

EOF

cat <<EOF

# Start mongodb by running

~/share/mongodb30/bin/mongod --config ~/share/mongodb30/mongod.cnf

EOF
