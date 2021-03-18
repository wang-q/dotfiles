# OpenCore

## i7-8700K

* Download tools needed

```shell script
mkdir -p ~/Downloads/hackintosh
cd ~/Downloads/hackintosh

curl -LO https://github.com/acidanthera/OpenCorePkg/releases/download/0.6.7/OpenCore-0.6.7-RELEASE.zip

curl -L https://github.com/corpnewt/ProperTree/archive/master.zip -o ProperTree.zip

curl -LO https://raw.githubusercontent.com/munki/macadmin-scripts/main/installinstallmacos.py

```

* Download an offline installer

```shell script
pip3 install xattr

sudo python installinstallmacos.py --compress
# 12

```
