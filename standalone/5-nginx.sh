#!/usr/bin/env bash

brew install nginx-full --with-autols --with-echo --with-unzip --with-websockify --with-xsltproc

export BREW_PREFIX=`brew --prefix`

mkdir -p ${BREW_PREFIX}/etc/nginx/sites-{enabled,available}
mkdir -p ${BREW_PREFIX}/etc/nginx/logs

cat <<EOF > ${BREW_PREFIX}/etc/nginx/nginx.conf
user `whoami` admin;
worker_processes  2;

error_log       ${BREW_PREFIX}/var/log/nginx/error.log;

events {
    worker_connections  1024;
}

http {
    include       mime.types;
    default_type  application/octet-stream;

    access_log      ${BREW_PREFIX}/var/log/nginx/access.log;

    # tcp
    sendfile           on;
    tcp_nopush         on;
    tcp_nodelay        off;
    keepalive_timeout  65;

    # timeouts
    client_header_timeout  3m;
    client_body_timeout    3m;
    send_timeout           3m;

    # max buffers
    client_max_body_size         50m;
    client_header_buffer_size    1k;
    large_client_header_buffers  4 4k;

    # sites
    include ${BREW_PREFIX}/etc/nginx/sites-enabled/*;
}

EOF

cat <<EOF > ${BREW_PREFIX}/etc/nginx/sites-available/default-ssl
server {
    listen       443 ssl;
    server_name  localhost;

    ssl_certificate      cert.pem;
    ssl_certificate_key  cert.key;

    ssl_session_cache    shared:SSL:1m;
    ssl_session_timeout  5m;

    ssl_ciphers  HIGH:!aNULL:!MD5;
    ssl_prefer_server_ciphers  on;

    location / {
        root   ${BREW_PREFIX}/var/www;
        index  index.html index.htm;
        autoindex on;
    }

    error_page   500 502 503 504  /50x.html;
    location = /50x.html {
        root   html;
    }
}

EOF

ln -s $BREW_PREFIX/etc/nginx/sites-available/default-ssl $BREW_PREFIX/etc/nginx/sites-enabled/default-ssl

if [ ! -e ${BREW_PREFIX}/etc/nginx/cert.key ];
then
    openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout ${BREW_PREFIX}/etc/nginx/cert.key -out ${BREW_PREFIX}/etc/nginx/cert.pem
fi


unset BREW_PREFIX
