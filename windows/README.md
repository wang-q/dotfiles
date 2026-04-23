# Setting-up scripts for Windows 11

This document provides step-by-step instructions for setting up a new Windows 11 system, including
essential configurations, development environment setup, and recommended software installations.

[TOC levels=2-3]: # ""
- [Setting-up scripts for Windows 11](#setting-up-scripts-for-windows-11)
  - [Get ISO](#get-iso)
  - [Install, active and update Windows](#install-active-and-update-windows)
  - [Enable some optional features of Windows](#enable-some-optional-features-of-windows)
  - [WSL 2](#wsl-2)
  - [Ubuntu 20.04/24.04](#ubuntu-20042404)
    - [Symlinks](#symlinks)
  - [`winget` and `Windows Terminal`](#winget-and-windows-terminal)
  - [Optional: Adjusting Windows](#optional-adjusting-windows)
    - [Disable MPO](#disable-mpo)
    - [Windows Defender exclusions](#windows-defender-exclusions)
  - [Optional: Packages Managements](#optional-packages-managements)
    - [Built-in Package Manager (winget)](#built-in-package-manager-winget)
    - [Cross-platform Binary Package manager (cbp)](#cross-platform-binary-package-manager-cbp)
    - [Alternative Package Managers](#alternative-package-managers)
  - [Optional: Python](#optional-python)
  - [Optional: Rust and C/C++](#optional-rust-and-cc)
  - [Optional: sysinternals](#optional-sysinternals)
  - [Optional: QuickLook Plugins](#optional-quicklook-plugins)
  - [Optional: Fonts](#optional-fonts)
  - [30 Rounds of R15](#30-rounds-of-r15)


Most commands in this document should be executed in `PowerShell`.

## Get ISO

Requirements:

* Windows 11
    * Build 22000 or later
    * English or Chinese Simplified
    * 64-bit
    * `winget` and `Windows Terminal` are included by default

Download:

* Windows 11 Business Edition (22H2, Jan 2023 Update)
    * [Magnet Link](magnet:?xt=urn:btih:01f5fe67f19cf107330490f658836c6037054f65&dn=zh-cn_windows_11_business_editions_version_22h2_updated_jan_2023_x64_dvd_82450200.iso&xl=5628721152)

## Install, active and update Windows

Basic system setup steps to get Windows 11 ready for use.

* Enable Virtualization in BIOS or VM

* Active Windows via KMS, <https://itsc.nju.edu.cn/21624/list.htm>
  or <https://github.com/massgravel/Microsoft-Activation-Scripts>

* Update Windows and then check system info

```powershell
# simple
winver

# details
systeminfo

```

After Windows updating, the Windows version is 22621.1265 as my current date.

## Enable some optional features of Windows

* Mount Windows ISO to D: (or others)

* Open PowerShell as an Administrator

```powershell
# .Net 2.5 and 3
DISM /Online /Enable-Feature /FeatureName:NetFx3 /All /LimitAccess /Source:D:\sources\sxs /NoRestart

# Online
# DISM /Online /Enable-Feature /FeatureName:NetFx3 /All /NoRestart

# SMB 1
Enable-WindowsOptionalFeature -Online -FeatureName SMB1Protocol -All -NoRestart

# Telnet
DISM /Online /Enable-Feature /FeatureName:TelnetClient /NoRestart

```

## WSL 2

Windows Subsystem for Linux (WSL) 2 allows you to run Linux distributions natively on Windows.

* Follow instructions of [this page](https://docs.microsoft.com/en-us/windows/wsl/wsl2-install)

* Open an elevated PowerShell

```powershell
# HyperV
Enable-WindowsOptionalFeature -Online -FeatureName VirtualMachinePlatform -NoRestart
Enable-WindowsOptionalFeature -Online -FeatureName Microsoft-Hyper-V -All -NoRestart

# # WSL 1
# Enable-WindowsOptionalFeature -Online -FeatureName Microsoft-Windows-Subsystem-Linux -NoRestart

```

Install the GA version of WSL, restart, then set WSL 2 as the default.

```powershell
wsl.exe --install

wsl --set-default-version 2

```

## Ubuntu 20.04/24.04

Search `Ubuntu` in Microsoft Store or use the following command lines.

```powershell
if (!(Test-Path Ubuntu2004.appx -PathType Leaf))
{
    Invoke-WebRequest -Uri https://aka.ms/wslubuntu2004 -OutFile Ubuntu2004.appx -UseBasicParsing
}
Add-AppxPackage .\Ubuntu2004.appx

```

Launch the distro from the Start menu, wait for a minute or two for the installation to complete,
and set up a new Linux user account.

The following command verifies the status of WSL:

```powershell
wsl -l -v

```

### Symlinks

* WSL: reduce the space occupied by virtual disks

```shell
cd

rm -fr Script data

ln -s /mnt/c/Users/wangq/Scripts/ ~/Scripts

ln -s /mnt/d/data/ ~/data
# ln -s /mnt/c/Users/wangq/data/ ~/data

```

* Windows: second disk
    * Open `cmd.exe` as an Administrator

```cmd
cd c:\Users\wangq\

mklink /D c:\Users\wangq\data d:\data

```

## `winget` and `Windows Terminal`

`winget` and `Windows Terminal` are now included by Windows 11

```powershell
winget install -s winget -e --id Git.Git

```

Open `Windows Terminal`

* Set `Default terminal application` to `Windows Terminal`.

* Set `Interaction` -> `Remove trailing white-space when pasting` to Off

* Hide unneeded `Profiles`.

## Optional: Adjusting Windows

Works with Windows 10 or 11.

```powershell
# Download and run directly
powershell.exe -Command "Invoke-WebRequest -Uri 'https://raw.githubusercontent.com/wang-q/dotfiles/master/windows/Setup-Windows.ps1' -OutFile 'Setup-Windows.ps1'"

# Use default preset (recommended)
powershell.exe -NoProfile -ExecutionPolicy Bypass -File "Setup-Windows.ps1"

```

Log in to the Microsoft Store and get updates from there.

* Remove "Home" (主文件夹) from Explorer in Windows 11

```cmd
reg add "HKCU\Software\Classes\CLSID\{f874310e-b6b7-47dc-bc84-b9e6b38f5903}" /v System.IsPinnedToNameSpaceTree /d 0 /t REG_DWORD /f

# manually accessing that view is still possible
explorer.exe shell:::{f874310e-b6b7-47dc-bc84-b9e6b38f5903}

```

### Disable MPO

In some cases, Chrome browser windows may flicker around the edges. This can potentially be improved
by disabling MPO.

```powershell
# Backup
reg export "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\Dwm" "DwmBackup.reg"

# Add the key
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\Dwm" /v OverlayTestMode /t REG_DWORD /d 5 /f

# Delete
reg delete "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\Dwm" /v OverlayTestMode /f

```

### Windows Defender exclusions

```powershell
Add-MpPreference -ExclusionPath "$HOME\Scripts"

```

## Optional: Packages Managements

### Built-in Package Manager (winget)

Windows Package Manager (winget) is the official package manager for Windows.

```powershell
# programming
winget install -s winget -e --id Oracle.JavaRuntimeEnvironment
winget install -s winget -e --id Oracle.JDK.18
winget install -s winget -e --id StrawberryPerl.StrawberryPerl
# winget install -e --id Python.Python
winget install -s winget -e --id RProject.R
# winget install -s winget -e --id RProject.Rtools
# winget install -s winget -e --id OpenJS.NodeJS.LTS
winget install -s winget -e --id Posit.RStudio
winget install -s winget -e --id Kitware.CMake
winget install -s winget -e --id Microsoft.PowerShell

# development
winget install -s winget -e --id GitHub.GitHubDesktop
winget install -s winget -e --id GitHub.cli
winget install -s winget -e --id WinSCP.WinSCP
winget install -s winget -e --id Microsoft.VisualStudioCode
# winget install -s msstore --accept-package-agreements "Visual Studio Code"
winget install -s winget -e --id ScooterSoftware.BeyondCompare.4
# winget install -s winget -e --id ScooterSoftware.BeyondCompare.5
# winget install -s winget -e --id JetBrains.Toolbox
# winget install -s winget -e --id RealVNC.VNCViewer
# winget install -s msstore --accept-package-agreements "Redis Insight"
winget install qishibo.AnotherRedisDesktopManager
winget install -s winget -e --id  Memurai.MemuraiDeveloper # Windows port of Redis
# memurai.exe --service-uninstall # I don't need this service
winget install -s winget -e --id Mobatek.MobaXterm
winget install -s winget -e --id ByteDance.Trae

# winget install -e --id WinFsp.WinFsp
# winget install -e --id SSHFS-Win.SSHFS-Win
# \\sshfs\REMUSER@HOST[\PATH]

# winget install -e --id Docker.DockerDesktop
# winget install -e --id VMware.WorkstationPlayer

# utils
winget install -s winget -e --id voidtools.Everything
# winget install -s msstore --accept-package-agreements Bandizip
# winget install -s msstore --accept-package-agreements NanaZip
winget install -s msstore --accept-package-agreements Rufus # need v3.18 or higher
winget install -s winget -e --id QL-Win.QuickLook
winget install -s winget -e --id AntibodySoftware.WizTree
# winget install -s msstore --accept-package-agreements "Microsoft PowerToys"
winget install -s winget -e --id qBittorrent.qBittorrent
winget install -s winget -e --id OlegDanilov.RapidEnvironmentEditor
# winget install -s winget -e --id valinet.ExplorerPatcher
# winget install -s winget -e --id Fndroid.ClashForWindows
winget install --id "CrystalDewWorld.CrystalDiskInfo"
winget install --id "CrystalDewWorld.CrystalDiskMark"
winget install --id RustDesk.RustDesk

# media
# winget install -s winget -e --id NetEase.CloudMusic
winget install -s winget -e --id HandBrake.HandBrake
winget install -s winget -e --id mpv.net
winget install voidtools.voidImageViewer

# apps
# winget install -s winget -e --id Mozilla.Firefox
winget install -s winget -e --id Tencent.WeChat
winget install -s winget -e --id Tencent.TencentMeeting
winget install -s winget -e --id Tencent.QQ
winget install -s winget -e --id Alibaba.DingTalk
winget install -s winget -e --id ByteDance.Feishu
# winget install -s winget -e --id Youdao.YoudaoTranslate
winget install -s winget -e --id Baidu.BaiduNetdisk
winget install -s winget -e --id DigitalScholar.Zotero
winget install -s msstore --accept-package-agreements "Microsoft Whiteboard"
winget install -s msstore --accept-package-agreements "Adobe Acrobat Reader DC"

# upgrading
winget upgrade --all --accept-package-agreements --source winget

# uninstall
winget uninstall "Windows web experience Pack"

```

### Cross-platform Binary Package manager (cbp)

I have developed a cross-platform package manager called `cbp` that can download prebuilt packages
and install them automatically.

```powershell
# Install cbp
# $ENV:ALL_PROXY='socks5h://localhost:7890'
iwr "https://github.com/wang-q/cbp/releases/latest/download/cbp.windows.exe" -OutFile cbp.windows.exe
.\cbp.windows.exe init

# Restart terminal to apply changes

# List available packages
cbp avail windows
cbp avail font          # font packages

# Install packages
cbp install curl jq
cbp install bat fd
cbp install sqlite3

# Manage packages
cbp list                # list installed packages
cbp list fd             # show package contents
cbp remove fd           # remove package

```

### Alternative Package Managers

* [scoop.md](scoop.md):
  > Scoop is an installer.
  >
  > The goal of Scoop is to let you use Unix-y programs in a normal Windows environment.
  >
  > Scoop focuses on open-source, command-line developer tools.

* Chocolatey and MSYS2 are other options but not recommended

## Optional: Python

The Microsoft Store version of Python has many permission restrictions.
Download the *Python Install Manager* from the [official website](https://www.python.org/downloads/windows/) and install it.

## Optional: Rust and C/C++

* [rust.md](../rust/windows.md)

## Optional: sysinternals

* Add `$HOME/bin` to Path

```powershell
mkdir $HOME/bin

# Add to Path
[Environment]::SetEnvironmentVariable(
    "Path",
    [Environment]::GetEnvironmentVariable("Path", [EnvironmentVariableTarget]::User) + ";$HOME\bin",
    [EnvironmentVariableTarget]::User)

```

* Download and extract

```powershell
scoop install aria2 unzip

$array = "DU", "ProcessExplorer", "ProcessMonitor", "RAMMap"

foreach ($app in $array)
{
    iwr "https://download.sysinternals.com/files/$app.zip" -O "$app.zip"
}

foreach ($app in $array)
{
    unzip "$app.zip" -d $HOME/bin -x Eula.txt
}

rm $HOME/bin/*.chm
rm $HOME/bin/*64.exe
rm $HOME/bin/*64a.exe

```

## Optional: QuickLook Plugins

<https://github.com/QL-Win/QuickLook/wiki/Available-Plugins>

```powershell
# office
$url = (
iwr https://api.github.com/repos/QL-Win/QuickLook.Plugin.OfficeViewer/releases/latest |
    Select-Object -Expand Content |
    jq -r '.assets[0].browser_download_url'
)
curl.exe -LO $url

# folder
$url = (
iwr https://api.github.com/repos/adyanth/QuickLook.Plugin.FolderViewer/releases/latest |
    Select-Object -Expand Content |
    jq -r '.assets[0].browser_download_url'
)
curl.exe -LO $url

```

Select the `qlplugin` file and press `Spacebar` to install the plugin.

## Optional: Fonts

```powershell
cbp install -t font helvetica
cbp install -t font fira
cbp install -t font jetbrains-mono

cbp install -t font source-han-sans
cbp install -t font source-han-serif
cbp install -t font lxgw-wenkai

```

## 30 Rounds of R15

<https://www.zhihu.com/question/384773491>

Save the following code as a batch file in the Cinebench R15 folder.

```bat
for /l %%x in (1, 1, 30) do (
"CINEBENCH Windows 64 Bit.exe" -cb_cpux >> "cpu_output.txt"
)

```

[Convert](https://api.1996wz.cn/html/test) the `cpu_output.txt` file.
