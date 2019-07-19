#!/usr/bin/env bash

echo "==> dkms"
sudo apt-get -y update
sudo apt-get -y install dkms

echo "==> virtualbox"
sudo tee -a /etc/apt/sources.list  <<EOF

# virtualbox
deb http://download.virtualbox.org/virtualbox/debian trusty contrib

EOF

wget -q https://www.virtualbox.org/download/oracle_vbox.asc -O- | sudo apt-key add -

sudo apt-get -y update
sudo apt-get -y install virtualbox-5.0

echo "==> packer"
mkdir -p ~/bin
wget -N -P /prepare/resource https://releases.hashicorp.com/packer/0.8.6/packer_0.8.6_linux_amd64.zip
unzip /prepare/resource/packer_*_linux_amd64.zip -d ~/bin

echo "==> vagrant"
wget -N -P /prepare/resource https://releases.hashicorp.com/vagrant/1.8.1/vagrant_1.8.1_x86_64.deb
sudo dpkg -i /prepare/resource/vagrant_1.8.1_x86_64.deb

echo "==> docker"
sudo apt-get -y update
sudo apt-get -y install apt-transport-https ca-certificates

sudo apt-key adv --keyserver hkp://p80.pool.sks-keyservers.net:80 --recv-keys 58118E89F3A912897C070ADBF76221572C52609D

sudo cat <<EOF > /etc/apt/sources.list.d/docker.list
deb https://apt.dockerproject.org/repo ubuntu-trusty main

EOF

sudo apt-get -y update
sudo apt-get -y purge lxc-docker
sudo apt-get -y install linux-image-extra-$(uname -r)
sudo apt-get -y install docker-engine
sudo service docker start

# Create a Docker group
sudo groupadd docker
sudo usermod -aG docker ${USER}

# Enable memory and swap accounting
sudo sed -i 's/GRUB_CMDLINE_LINUX=""/GRUB_CMDLINE_LINUX="cgroup_enable=memory swapaccount=1"/' /etc/default/grub
sudo update-grub
