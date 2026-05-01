# Ubuntu 26.04

## Distro

https://learn.microsoft.com/en-us/windows/wsl/use-custom-distro


```powershell
# Pull Ubuntu 26.04 image
docker pull ubuntu:26.04

# Create a temp container (ls / just starts it)
docker run -t --name wsl_export ubuntu:26.04 ls /

# Directory for the exported tar
mkdir -p $HOME\VM

# Exclude from Windows Defender — needed for I/O performance (requires admin)
Start-Process powershell -ArgumentList "-Command Add-MpPreference -ExclusionPath '$HOME\VM'" -Verb RunAs -Wait

# Export container to tar
docker export wsl_export > $HOME\VM\resolute.tar

docker rm wsl_export

# Import tar into WSL as instance "resolute"
wsl --import resolute $HOME\VM\resolute $HOME\VM\resolute.tar

# List all WSL instances
wsl -l -v

# Requires WSL 2.6.2+
wsl --version 
# wsl --update

# Start the resolute instance
wsl -d resolute

# After editing wsl.conf, restart the instance to apply
# wsl --terminate resolute

# wsl --unregister resolute --force

```

## Base system

As `root`

```bash
apt-get -y update
apt-get -y upgrade

# Pre-set timezone to avoid interactive prompts during install
apt-get -y install debconf-utils
echo "tzdata tzdata/Areas select Asia" | debconf-set-selections
echo "tzdata tzdata/Zones/Asia select Shanghai" | debconf-set-selections
apt-get -y install tzdata

# plocate: fast file search; build DB early while the system is small (~7 min)
# apt-get -y install plocate

# sudo and vim
apt-get -y install sudo vim

# Network tools (ip, ping, ifconfig) and process tools (ps)
apt-get -y install iproute2 iputils-ping net-tools procps

# systemd as init
apt-get -y install systemd systemd-sysv

```

## Add user

As `root`

```bash
myUsername=wangq

useradd -s /bin/bash -m -G sudo $myUsername

passwd $myUsername

# WSL default user
echo -e "[user]\ndefault=$myUsername" >> /etc/wsl.conf
# Don't mix Windows PATH into Linux
echo -e "[interop]\nappendWindowsPath=false" >> /etc/wsl.conf
# Enable systemd
echo -e "[boot]\nsystemd=true" >> /etc/wsl.conf
echo -e "[automount]\ncgroups=v2" >> /etc/wsl.conf
```

Restart the resolute instance

```bash
# Verify systemd is running as pid 1
ps -p 1 -o comm=

```

## ssh

```bash
sudo apt -y update
sudo apt -y upgrade

sudo apt -y install ssh ufw

sudo systemctl start ssh
sudo systemctl enable ssh
sudo systemctl status ssh

sudo ufw allow ssh
sudo ufw enable

```

### From a Windows machine

https://superuser.com/questions/1747549/alternative-to-ssh-copy-id-on-windows

```powershell
type $HOME\.ssh\id_rsa.pub | ssh wangq@ser5 "cat >> .ssh/authorized_keys"

```

## deb-src and apt-rdepends

```bash
sudo sed -i 's/^Types: deb$/Types: deb deb-src/' /etc/apt/sources.list.d/ubuntu.sources
sudo apt-get -y update

sudo apt-get -y install apt-rdepends
apt-rdepends --build-depends --print-state --follow=DEPEND gnuplot

```

## smb

https://ubuntu.com/tutorials/install-and-configure-samba

```bash
# server
sudo apt -y update
sudo apt -y upgrade

sudo apt -y install samba

# Add shared folder config
sudo bash -c 'cat >> /etc/samba/smb.conf <<EOF
[wangq]
    comment = Home Directory of wangq
    path = /home/wangq
    browsable = yes
    read only = no
EOF'

sudo service smbd restart
sudo ufw allow samba

# Set Samba password for user
sudo smbpasswd -a wangq

# client
sudo apt -y update
sudo apt -y install cifs-utils

```

## Disks

* `/home/wangq/data` 2 TB SSD

`/dev/disk/by-id/usb-Samsung_PSSD_T7_S5TDNS0T330981K-0:0-part1 /home/wangq/data auto nosuid,nodev,nofail 0 0`

## nfs

Qnap

* Enable NFS v2/v3 and/or NFS v4
* Edit Shared Folder Permission
  * NFS host access

![nfs.png](../images/nfs.png)

```bash
# ubuntu
sudo apt -y update
sudo apt -y install nfs-common

mkdir -p /home/wangq/nfs

# Mount QNAP NFS share
sudo mount -t nfs 192.168.31.209:/share/data /home/wangq/nfs
sudo umount /home/wangq/nfs

# /etc/fstab
192.168.31.209:/share/data /home/wangq/nfs nfs rsize=8192,wsize=8192,timeo=14,intr

sudo systemctl daemon-reload

```

## Desktop

### Gnome remote desktop

```bash
sudo ufw allow from any to any port 3389 proto tcp
sudo ufw allow from any to any port 3390 proto tcp
sudo ufw reload

```

### Gnome shell

```bash
# WSL
# sudo apt -y install ubuntu-desktop-minimal

# Space to preview files (like macOS Quick Look)
sudo apt -y install gnome-sushi

# Extension Manager + system monitor dependencies
sudo apt -y install gnome-shell-extension-manager gir1.2-gtop-2.0 lm-sensors

# Open the Extension Manager (installed above), search for
# * Vitals
# * Allow Locked Remote Desktop

# https://askubuntu.com/questions/1515740/swap-memory-really-leak-on-freshish-install-of-24-04
gnome-extensions disable ding@rastersoft.com

```

### R studio

```bash
# sudo apt-get install gdebi-core

# wget https://download2.rstudio.org/server/jammy/amd64/rstudio-server-2024.09.1-394-amd64.deb
# sudo gdebi rstudio-server-2024.09.1-394-amd64.deb

# sudo rstudio-server verify-installation
# # sudo apt-get remove --purge rstudio-server

# wget https://download1.rstudio.org/electron/jammy/amd64/rstudio-2024.09.1-394-amd64.deb
# sudo gdebi rstudio-2024.09.1-394-amd64.deb

```

### AppImage

```bash
sudo apt -y install curl
# AppImage runtime dependency
sudo apt -y install libfuse2t64

mkdir -p ~/bin

# curl -LO https://github.com/libnyanpasu/clash-nyanpasu/releases/download/v1.6.1/clash-nyanpasu_1.6.1_amd64.AppImage
# chmod +x clash-nyanpasu_1.6.1_amd64.AppImage
# mv clash-nyanpasu_1.6.1_amd64.AppImage ~/bin

mkdir -p ~/bin

sudo apt update
# Qt/X11 dependencies for AppImages
sudo apt install -y libxcb-icccm4 libxcb-image0 libxcb-keysyms1 libxcb-randr0 libxcb-render-util0 libxcb-xinerama0 libxcb-xkb1 libxkbcommon-x11-0

```

### Apps

```bash

# zed
curl -f https://zed.dev/install.sh | sh

```

## Snap

Accepts system proxy

```bash
sudo snap install ghostty --classic
sudo snap install rustrover --classic
sudo snap install gitpeach-desktop --classic

```

## Flatpak

```bash
# Flatpak setup
sudo apt -y install flatpak
flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
flatpak remote-add --if-not-exists --user flathub https://flathub.org/repo/flathub.flatpakrepo

# Honkai Star Rail launcher
flatpak remote-add --if-not-exists --user launcher.moe https://gol.launcher.moe/gol.launcher.moe.flatpakrepo
# --user can't download wine and dxvk, so install runtime at system level
sudo flatpak install org.gnome.Platform//47
flatpak install launcher.moe moe.launcher.the-honkers-railway-launcher

# flatpak install --user flathub io.mpv.Mpv
# flatpak install --user flathub info.smplayer.SMPlayer
# flatpak install --user flathub io.github.celluloid_player.Celluloid
# flatpak install --user flathub org.videolan.VLC

# flatpak install --user flathub io.github.shiftey.Desktop
flatpak install -y --user flathub com.visualstudio.code

flatpak install -y --user flathub org.qbittorrent.qBittorrent
flatpak install -y --user fr.handbrake.ghb
flatpak install -y --user flathub org.zotero.Zotero
flatpak install -y --user flathub com.tencent.WeChat
flatpak install -y --user flathub com.tencent.wemeet
flatpak install -y --user flathub cn.wps.wps_365

# Edge is blurry at 200% scaling via apt; Flatpak version is sharper
flatpak install -y --user flathub com.microsoft.Edge

# flatpak install -y --user flathub com.jetbrains.RustRover

# https://itsfoss.com/gpu-usage-linux/
# flatpak install -y --user flathub io.missioncenter.MissionCenter

# Clean up unused packages
flatpak uninstall --unused

```

## Waydroid

```bash
sudo apt -y install curl ca-certificates
curl -s https://repo.waydro.id | sudo bash
sudo apt -y install waydroid

# Set resolution and fake WiFi
waydroid prop set persist.waydroid.width "1280"
waydroid prop set persist.waydroid.height "720"
waydroid prop set persist.waydroid.fake_wifi '*'

sudo waydroid container restart

# Remove pre-installed Android apps
sudo waydroid shell
pm uninstall --user 0 com.android.calculator2
pm uninstall --user 0 org.lineageos.etar
pm uninstall --user 0 com.android.gallery3d
pm uninstall --user 0 org.lineageos.eleven
pm uninstall --user 0 org.lineageos.recorder
pm uninstall --user 0 com.android.contacts

# Firewall rules for Waydroid networking
sudo waydroid session stop
sudo waydroid container stop

sudo ufw allow 67
sudo ufw allow 53
sudo ufw default allow FORWARD

# ARM translation layer (run ARM apps on x86)
sudo apt install lzip

git clone https://github.com/casualsnek/waydroid_script
cd waydroid_script
python3 -m venv venv
venv/bin/pip install -r requirements.txt
sudo venv/bin/python3 main.py install libndk
sudo venv/bin/python3 main.py install libhoudini

# Download APKs from apkmirror.com
waydroid app install ~/Download/com.

```
