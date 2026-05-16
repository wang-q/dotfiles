# CentOS in incus

## The base system

```bash
sudo apt-get -y install docker.io
sudo usermod -aG docker $USER

sudo apt-get -y install incus

cat <<EOF | sudo incus admin init --preseed
networks:
- config:
    ipv4.address: 10.99.0.1/24
    ipv4.nat: "true"
    ipv6.address: none
  name: incusbr0
  type: bridge
storage_pools:
- config:
    source: /var/lib/incus/storage-pools/default
  name: default
  driver: dir
profiles:
- name: default
  devices:
    root:
      path: /
      pool: default
      type: disk
    eth0:
      network: incusbr0
      type: nic
EOF

sudo usermod -aG incus-admin $USER

sudo ufw allow in on incusbr0
sudo ufw route allow in on incusbr0

```

> **Re-login required:** group memberships above only take effect after logging out and back in.
> Or run `newgrp docker` then `newgrp incus-admin` in the current shell.

```bash
# Pull CentOS image
docker pull wangq/centos:master

# Create a temp container (ls -l / just starts it)
docker run -t --name centos_export wangq/centos:master bash -c 'ls -l /'

# Directory for the exported tar
mkdir -p $HOME/VM

docker export centos_export > $HOME/VM/centos.tar

docker rm centos_export

# Create metadata.yaml for incus image
cat > $HOME/VM/metadata.yaml <<EOF
architecture: x86_64
creation_date: $(date +%s)
properties:
  description: CentOS
  os: CentOS
EOF

# Pack metadata into a tiny tarball
tar cf $HOME/VM/metadata.tar -C $HOME/VM metadata.yaml

# Import: metadata.tar + rootfs.tar, no repackaging needed
incus image import $HOME/VM/metadata.tar $HOME/VM/centos.tar --alias centos

# Create and start the CentOS instance from the centos image
incus launch centos CentOS

# Create a systemd service to auto-run dhclient on boot
cat > /tmp/dhclient.service <<'EOF'
[Unit]
Description=DHCP client for eth0
After=network.target

[Service]
Type=oneshot
ExecStart=/sbin/dhclient eth0
RemainAfterExit=yes

[Install]
WantedBy=multi-user.target
EOF
incus file push /tmp/dhclient.service CentOS/etc/systemd/system/dhclient.service
rm /tmp/dhclient.service
incus exec CentOS -- ln -sf /etc/systemd/system/dhclient.service /etc/systemd/system/multi-user.target.wants/dhclient.service

# Docker images strip D-Bus; enable it so systemd can manage services
incus exec CentOS -- ln -sf /usr/lib/systemd/system/dbus.service /etc/systemd/system/multi-user.target.wants/dbus.service
incus exec CentOS -- mkdir -p /etc/systemd/system/sockets.target.wants
incus exec CentOS -- ln -sf /usr/lib/systemd/system/dbus.socket /etc/systemd/system/sockets.target.wants/dbus.socket

# Optional: reserve a static IP
# incus config device override CentOS eth0 ipv4.address=10.99.0.100

# Restart — systemd will now auto-run dhclient
incus stop CentOS --force
incus start CentOS

incus exec CentOS -- ifconfig eth0

# List all instances (IP should now appear)
incus list

# Enter the instance
incus exec CentOS -- bash

# Stop the instance
# incus stop CentOS --force

# Start an existing instance (use instead of launch if already created)
# incus start CentOS

# Delete the instance
# incus delete CentOS

```
