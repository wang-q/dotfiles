# macOS

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
