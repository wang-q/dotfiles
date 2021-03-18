# OpenCore

## i7-8700K

* Hardware
  * INTEL Core i7-8700K Coffee Lake 6-Core 3.7 GHz (4.7 GHz Turbo)
    * HD 630
  * GIGABYTE Z370N WIFI Mini ITX LGA1151
    * Sound - Realtek ALC1220
    * Network - Intel GbE
    * Wireless

* Download needed tools

```shell script
mkdir -p ~/Downloads/hackintosh
cd ~/Downloads/hackintosh

curl -LO https://raw.githubusercontent.com/munki/macadmin-scripts/main/installinstallmacos.py

curl -L https://github.com/corpnewt/MountEFI/archive/update.zip -o MountEFI.zip

curl -LO https://github.com/acidanthera/OpenCorePkg/releases/download/0.6.7/OpenCore-0.6.7-RELEASE.zip

curl -L https://github.com/corpnewt/ProperTree/archive/master.zip -o ProperTree.zip

```

* Format a USB disk via Disk Utility
  * Name - MyVolume
  * Format - Mac OS Extended (Journaled)
  * Scheme - GUID

* `createinstallmedia`

```shell script
cd ~/Downloads/hackintosh

pip3 install xattr

sudo python installinstallmacos.py
# select
# 13      001-68446    10.15.7    19H15  2020-11-11  macOS Catalina

hdiutil attach Install_*.dmg
cp -pr /Volumes/Install\ macOS\ Catalina/Install\ macOS\ Catalina.app /Applications/

hdiutil detach /Volumes/Install\ macOS\ Catalina

sudo /Applications/Install\ macOS\ Catalina.app/Contents/Resources/createinstallmedia --volume /Volumes/MyVolume
# type Y

```
