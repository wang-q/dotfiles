# Scripts for standalone servers

This folder contains setup scripts for standalone servers.

## Prepare

In Vagrant boxes, I created shared folder `/prepare/` linking to `~/Scripts/egavm/prepare/`. So for
multiple users in a standalone server, it would be convenient to create a symbolic link
`/prepare/resource/` to `~/Scripts/egavm/prepare/resource/`.

```bash
sudo mkdir -p /prepare
sudo chown `whoami`:users /prepare

ln -s ~/Scripts/egavm/prepare/resource /prepare/resource
chmod 775 ~/Scripts/egavm/prepare/resource/
```

## Software

* Mongodb 3.x
* Self compiled mysql 5.1
* Pre-builded NCBI blast DB
* Apache httpd (for webblast)
* blast2go
