# OpenCore

## i7-8700K Z370

### Hardware

* INTEL Core i7-8700K Coffee Lake 6-Core 3.7 GHz (4.7 GHz Turbo)
  * HD 630
* GIGABYTE Z370N WIFI Mini ITX LGA1151
  * Sound - Realtek ALC1220
  * Network - Intel GbE
  * Wireless

### BIOS settings

1. Save & Exit → Load Optimized Defaults
2. M.I.T. → Advanced Memory Settings Extreme Memory Profile(X.M.P.) : Disabled
3. BIOS → Fast Boot : Disabled
4. BIOS → LAN PXE Boot Option ROM : Disabled
5. BIOS → Storage Boot Option Control : UEFI
6. Peripherals → Trusted Computing → Security Device Support : Disabled
7. Peripherals → Network Stack Configuration → Network Stack : Disabled
8. Peripherals → USB Configuration → Legacy USB Support : Auto/Enabled
9. Peripherals → USB Configuration → XHCI Hand-off : Enabled
10. Chipset → Vt-d : Disabled
11. Chipset → Wake on LAN Enable : Disabled
12. Chipset → IOAPIC 24-119 Entries : Enabled

Intel iGPU:

1. Peripherals → Initial Display Output : IGFX
2. Chipset → Integrated Graphics : Enabled
3. Chipset → DVMT Pre-Allocated : 64M (if this setting isn’t showing then:
   1. Set Integrated Graphics: Enabled.
   2. Save and Exit BIOS by pressing F10.
   3. Reenter BIOS upon computer restart and it should be there.)

### Download needed tools

```shell script
mkdir -p ~/Downloads/hackintosh
cd ~/Downloads/hackintosh

curl -LO https://raw.githubusercontent.com/munki/macadmin-scripts/main/installinstallmacos.py

curl -L https://github.com/corpnewt/MountEFI/archive/update.zip -o MountEFI.zip

curl -LO https://github.com/acidanthera/OpenCorePkg/releases/download/0.6.7/OpenCore-0.6.7-RELEASE.zip

curl -L https://github.com/corpnewt/ProperTree/archive/master.zip -o ProperTree.zip

curl -L https://github.com/corpnewt/GenSMBIOS/archive/master.zip -o GenSMBIOS.zip

unzip MountEFI.zip
chmod +x MountEFI-update/MountEFI.command

unzip ProperTree.zip
chmod +x ProperTree-master/ProperTree.command

unzip GenSMBIOS.zip
chmod +x GenSMBIOS-master/GenSMBIOS.command

```

### Format a USB disk via Disk Utility

* Name - MyVolume
* Format - Mac OS Extended (Journaled)
* Scheme - GUID

### `createinstallmedia`

```shell script
cd ~/Downloads/hackintosh

pip3 install xattr

sudo python installinstallmacos.py
# select
# 13      001-68446    10.15.7    19H15  2020-11-11  macOS Catalina

hdiutil attach Install_*.dmg

# cp to /Applications/
# It will be much faster
cp -pr /Volumes/Install\ macOS\ Catalina/Install\ macOS\ Catalina.app /Applications/

hdiutil detach /Volumes/Install\ macOS\ Catalina

sudo /Applications/Install\ macOS\ Catalina.app/Contents/Resources/createinstallmedia --volume /Volumes/MyVolume
# type Y

./MountEFI-update/MountEFI.command

```

### Adding The Base OpenCore Files

```shell script
cd ~/Downloads/hackintosh

./MountEFI-update/MountEFI.command
# interactively select the USB driver

unzip OpenCore-0.6.7-RELEASE.zip X64/*

mv X64/EFI /Volumes/EFI/

# Remove unneeded tools
find /Volumes/EFI/EFI/OC/Drivers/ -type f |
    grep -v 'OpenRuntime.efi' |
    xargs rm

find /Volumes/EFI/EFI/OC/Tools/ -type f |
    grep -v 'OpenShell.efi' |
    xargs rm

```

### Gathering files

```shell script
cd ~/Downloads/hackintosh

mkdir -p OcBinaryData

# HfsPlus.efi
curl -LO https://raw.githubusercontent.com/acidanthera/OcBinaryData/master/Drivers/HfsPlus.efi
cp HfsPlus.efi /Volumes/EFI/EFI/OC/Drivers/

# Lilu.kext
curl -LO https://github.com/acidanthera/Lilu/releases/download/1.5.1/Lilu-1.5.1-RELEASE.zip
unzip Lilu-1.5.1-RELEASE.zip
mv Lilu.kext /Volumes/EFI/EFI/OC/Kexts/

# VirtualSMC and Plugins
curl -LO https://github.com/acidanthera/VirtualSMC/releases/download/1.2.1/VirtualSMC-1.2.1-RELEASE.zip

unzip -o VirtualSMC-1.2.1-RELEASE.zip Kexts/VirtualSMC.kext/*
mv Kexts/VirtualSMC.kext /Volumes/EFI/EFI/OC/Kexts/

unzip -o VirtualSMC-1.2.1-RELEASE.zip Kexts/SMCProcessor.kext/*
mv Kexts/SMCProcessor.kext /Volumes/EFI/EFI/OC/Kexts/

unzip -o VirtualSMC-1.2.1-RELEASE.zip Kexts/SMCSuperIO.kext/*
mv Kexts/SMCSuperIO.kext /Volumes/EFI/EFI/OC/Kexts/

# Graphics - WhateverGreen
curl -LO https://github.com/acidanthera/WhateverGreen/releases/download/1.4.8/WhateverGreen-1.4.8-RELEASE.zip
unzip -o WhateverGreen-1.4.8-RELEASE.zip
mv WhateverGreen.kext /Volumes/EFI/EFI/OC/Kexts/

# Audio - AppleALC
curl -LO https://github.com/acidanthera/AppleALC/releases/download/1.5.8/AppleALC-1.5.8-RELEASE.zip
unzip -o AppleALC-1.5.8-RELEASE.zip
mv AppleALC.kext /Volumes/EFI/EFI/OC/Kexts/

# Ethernet
curl -LO https://github.com/acidanthera/IntelMausi/releases/download/1.0.5/IntelMausi-1.0.5-RELEASE.zip
unzip -o IntelMausi-1.0.5-RELEASE.zip
mv IntelMausi.kext /Volumes/EFI/EFI/OC/Kexts/

curl -LO https://github.com/khronokernel/SmallTree-I211-AT-patch/releases/download/1.3.0/SmallTreeIntel82576.kext.zip
unzip -o SmallTreeIntel82576.kext.zip
mv SmallTreeIntel82576.kext /Volumes/EFI/EFI/OC/Kexts/

# SSDTs
curl -LO https://raw.githubusercontent.com//dortania/Getting-Started-With-ACPI/master/extra-files/compiled/SSDT-PLUG-DRTNIA.aml
mv SSDT-PLUG-DRTNIA.aml /Volumes/EFI/EFI/OC/ACPI/

curl -LO https://raw.githubusercontent.com//dortania/Getting-Started-With-ACPI/master/extra-files/compiled/SSDT-EC-USBX-DESKTOP.aml
mv SSDT-EC-USBX-DESKTOP.aml /Volumes/EFI/EFI/OC/ACPI/

curl -LO https://raw.githubusercontent.com//dortania/Getting-Started-With-ACPI/master/extra-files/compiled/SSDT-AWAC.aml
mv SSDT-AWAC.aml /Volumes/EFI/EFI/OC/ACPI/

# SSDT-PMC isn't required by Z370 

```

### `config.plist` Setup

```shell script
cd ~/Downloads/hackintosh

unzip OpenCore-0.6.7-RELEASE.zip Docs/Sample.plist

mv Docs/Sample.plist /Volumes/EFI/EFI/OC/config.plist

./ProperTree-master/ProperTree.command /Volumes/EFI/EFI/OC/config.plist
# press Cmd/Ctrl + Shift + R and point it at your EFI/OC folder to perform a "Clean Snapshot"

```

Following steps in <https://dortania.github.io/OpenCore-Install-Guide/config.plist/coffee-lake.html#starting-point>
