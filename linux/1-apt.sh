#!/usr/bin/env bash

echo "====> Install softwares via apt-get <===="

# echo "==> Disabling the release upgrader"
# sudo sed -i.bak 's/^Prompt=.*$/Prompt=never/' /etc/update-manager/release-upgrades

# echo "==> Disable whoopsie"
# sudo sed -i 's/report_crashes=true/report_crashes=false/' /etc/default/whoopsie
# sudo service whoopsie stop

echo "==> Install linuxbrew dependencies"
sudo apt-get -y update
sudo apt-get -y upgrade
sudo apt-get -y install build-essential curl file git
sudo apt-get -y install pkg-config libbz2-dev zlib1g-dev liblzma-dev libzstd-dev libexpat1-dev unzip

echo "==> Install CLI tools"
sudo apt-get -y install aptitude net-tools parallel vim xsltproc numactl pigz fontconfig fontconfig-config

echo "==> Install development libraries"
# sudo apt-get -y install libreadline-dev libedit-dev
sudo apt-get -y install libdb-dev libxml2-dev libssl-dev libncurses-dev libgd-dev
# gdal: /usr/lib/libgdal.so: undefined reference to `TIFFReadDirectory@LIBTIFF_4.0'
# sudo apt-get -y install gdal-bin gdal-data libgdal-dev
# GSL: old package names were libgsl0ldbl / libgsl0-dev
# sudo apt-get -y install libgsl-dev

# English word list for /usr/share/dict/words
sudo apt-get -y install wamerican

# GTK3 dependencies for alignDB (install on a fresh machine to avoid conflicts)
# echo "==> Install gtk3"
#sudo apt-get -y install libcairo2-dev libglib2.0-0 libglib2.0-dev libgtk-3-dev libgirepository1.0-dev
#sudo apt-get -y install gir1.2-glib-2.0 gir1.2-gtk-3.0 gir1.2-webkit-3.0

# echo "==> Install gtk3 related tools"
# sudo apt-get -y install xvfb glade

# echo "==> Install graphics tools"
# sudo apt-get -y install gnuplot graphviz imagemagick

#echo "==> Install nautilus plugins"
#sudo apt-get -y install nautilus-open-terminal nautilus-actions

# MySQL will be installed separately.
# Remove system MySQL to avoid conflicts with linuxbrew.
# echo "==> Remove system provided mysql"
# sudo apt-get -y purge mysql-common

echo "====> Basic software installation complete! <===="
