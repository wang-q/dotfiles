# macOS

## ExtHome

```shell
diskutil info /Volumes/ExtHome |
    grep "Volume UUID"

sudo vim /etc/fstab
# nobrowse: 访达自动隐藏盘符
# noeject: 系统禁用推出功能
# UUID=365E2F47-DB0F-4DB5-8D61-2511E3B86749 none apfs ro,nobrowse,noeject 0 0

sudo ditto /Users/wangq/Applications /Volumes/ExtHome/Applications &&
    sudo rm -rf /Users/wangq/Applications
sudo ditto /Users/wangq/Downloads /Volumes/ExtHome/Downloads &&
    sudo rm -rf /Users/wangq/Downloads
sudo ditto /Users/wangq/Movies /Volumes/ExtHome/Movies &&
    sudo rm -rf /Users/wangq/Movies
sudo ditto /Users/wangq/Music /Volumes/ExtHome/Music &&
    sudo rm -rf /Users/wangq/Music
sudo ditto /Users/wangq/Pictures /Volumes/ExtHome/Pictures &&
    sudo rm -rf /Users/wangq/Pictures

sudo ditto /Users/wangq/data /Volumes/ExtHome/data &&
    sudo rm -rf /Users/wangq/data
sudo ditto /Users/wangq/material /Volumes/ExtHome/material &&
    sudo rm -rf /Users/wangq/material
sudo ditto /Users/wangq/Scripts /Volumes/ExtHome/Scripts &&
    sudo rm -rf /Users/wangq/Scripts
sudo ditto /Users/wangq/share /Volumes/ExtHome/share &&
    sudo rm -rf /Users/wangq/share

ln -s /Volumes/ExtHome/Applications /Users/wangq/Applications
ln -s /Volumes/ExtHome/Downloads /Users/wangq/Downloads
ln -s /Volumes/ExtHome/Movies /Users/wangq/Movies
ln -s /Volumes/ExtHome/Music /Users/wangq/Music
ln -s /Volumes/ExtHome/Pictures /Users/wangq/Pictures

ln -s /Volumes/ExtHome/data /Users/wangq/data
ln -s /Volumes/ExtHome/material /Users/wangq/material
ln -s /Volumes/ExtHome/Scripts /Users/wangq/Scripts
ln -s /Volumes/ExtHome/share /Users/wangq/share 

```

## nfs

```shell
sudo mkdir -p /Volumes/NAS-NFS
sudo chown $USER:staff /Volumes/NAS-NFS

ln -s /Volumes/NAS-NFS ~/nfs

# one shot
sudo mount -t nfs -o resvport,nolock,rsize=1048576,wsize=1048576,timeo=14,hard 192.168.31.209:/data /Volumes/NAS-NFS
# sudo umount /Volumes/NAS-NFS

# /etc/fstab
192.168.31.209:/data    /Volumes/NAS-NFS    nfs    resvport,nolock,rsize=1048576,wsize=1048576,timeo=14,hard    0    0

ln -s /Volumes/NAS-NFS ~/nfs

```
