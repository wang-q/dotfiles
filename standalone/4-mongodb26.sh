#!/usr/bin/env bash

mkdir -p $HOME/share/

echo "====> Install MongoDB <===="

mkdir -p $HOME/share/mongodb26

if [[ `uname` == 'Darwin' ]];
then
    echo "==> download"
    cd /prepare/resource/
    wget -N http://fastdl.mongodb.org/osx/mongodb-osx-x86_64-2.6.12.tgz

    echo "==> untar"
    cd $HOME/share/
    tar xvfz /prepare/resource/mongodb-osx-x86_64-2.6.12.tgz
    cp -R -n mongodb-osx*/ mongodb26

    rm -fr mongodb-osx*/
else
    echo "==> download"
    cd /prepare/resource/
    wget -N http://fastdl.mongodb.org/linux/mongodb-linux-x86_64-2.6.12.tgz

    echo "==> untar"
    cd $HOME/share/
    tar xvfz /prepare/resource/mongodb-linux-x86_64-2.6.12.tgz
    cp -R -n mongodb-linux*/bin mongodb26

    rm -fr mongodb-linux*/
fi

mkdir -p $HOME/share/mongodb26/log
mkdir -p $HOME/share/mongodb26/data

echo "==> cnf file"
cat <<EOF > $HOME/share/mongodb26/mongod.cnf
systemLog:
    destination: file
    path: $HOME/share/mongodb26/log/mongod.log
    logAppend: true
storage:
    dbPath: $HOME/share/mongodb26/data
    directoryPerDB: true
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

~/share/mongodb26/bin/mongod --config ~/share/mongodb26/mongod.cnf

EOF
