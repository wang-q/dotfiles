# Common

## 用 screen 启动几个常用后台程序

```bash
screen -wipe # Remove dead screens
screen -dmS op htop # Start a screen named `op` and run `htop`

# screen -S op -x -X screen perl -MPod::POM::Web -e "server 8088"
# rm ~/share/mongodb/data/mongod.lock
# screen -S op -x -X screen ~/share/mongodb/bin/mongod --config ~/share/mongodb/mongod.cnf

# screen -S op -x -X screen numactl --interleave=all ~/share/mongodb/bin/mongod --config ~/share/mongodb/mongod.cnf

screen -S op -x -X screen redis-server
screen -S op -x -X screen mysqld_safe

# linux, v2ray 5
screen -S op -x -X screen ~/v2ray/v2ray run -config ~/config.json

# mac, v2ray 4
screen -S op -x -X screen v2ray -config ~/config.json

```

## v2ray and vmess

```shell script
# brew install v2ray

aria2c -c https://github.com/v2fly/v2ray-core/releases/download/v5.0.8/v2ray-linux-64.zip

curl -LO https://raw.githubusercontent.com/boypt/vmess2json/master/vmess2json.py

export vmess_url=vmess://your_secret_url
python3 vmess2json.py --inbounds socks:1080 ${vmess_url} > config.json

v2ray run -config config.json &

export ALL_PROXY=socks5h://localhost:1080

# export ALL_PROXY=socks5h://192.168.31.116:10808

curl google.com

```

## 滚轮

Disable mouse scrolling through terminal command history on Mac terminal

https://unix.stackexchange.com/questions/511740/disable-mouse-scrolling-through-terminal-command-history-on-mac-terminal

```shell
tput rmcup

```

## 列出所有子目录的 git 状态

Ideas from this
[SO post](http://stackoverflow.com/questions/3497123/run-git-pull-over-all-subdirectories).

* Status of all repos

```shell
find ~/Scripts -type d -mindepth 1 -maxdepth 3 -name ".git" |
    sort |
    parallel -r -k -j 1 "echo {//}; git -C {//} status; echo ===="

```

* Only show repos needing attentions

```bash
find ~/Scripts -type d -mindepth 1 -maxdepth 3 -name ".git" |
    sort |
    parallel -r -k -j 1 "echo {//}; git -C {//} status; echo ====" |
    perl -e '
        @lines = <>;
        @sections = split /\=+/, join("", @lines);
        print "\n==> Behind\n";
        print for grep {/Your branch is behind/} @sections;
        print "\n==> Ahead\n";
        print for grep {/Your branch is ahead/} @sections;
        print "\n==> Not staged\n";
        print for grep {/Changes not staged for commit/} @sections;
        print "\n==> Untrack\n";
        print for grep {/Untracked files/} @sections;
    '

```

## `brew update` failed

```shell
 brew update-reset

```

## cloc of tracked files

```bash
cloc $(git ls-files)
```

```bash
find ~/Scripts -type d -mindepth 1 -maxdepth 3 -name ".git" \
    | sort > dirs.tmp

cat dirs.tmp \
    | parallel -r -k -j 1 "
    	cd {//}; git ls-files | perl -MCwd -nle 'print Cwd::realpath(\$_)'
    " \
    > files.tmp

cloc --list-file files.tmp --exclude-lang HTML,YAML,RobotFramework

rm dirs.tmp files.tmp

```

## tar & pigz

```bash

time tar -xzvf lav.tar.gz
# real    0m21.428s
# user    0m13.442s
# sys     0m2.828s

time tar -czvf lav1.tar.gz *.lav
# real    4m42.678s
# user    4m34.581s
# sys     0m4.188s

time tar -cvf - *.lav | gzip > lav2.tar.gz
# real    4m36.802s
# user    4m33.793s
# sys     0m4.350s

time tar -cvf - *.lav | pigz -p 4 > lav3.tar.gz
# real    1m12.889s
# user    4m47.680s
# sys     0m7.042s

```

## youtube-dl with socks proxy

On May 10, 2016, youtube-dl supports socks proxy.

```bash
youtube-dl \
    -o "%(title)s.%(ext)s" --recode-video mp4 \
    --format bestvideo[ext!=webm]+bestaudio[ext!=webm]/best[ext!=webm] \
    --restrict-filenames --continue --ignore-errors --no-call-home --no-mtime \
    --write-sub --write-auto-sub --embed-subs --sub-lang en \
    --proxy socks5://127.0.0.1:1080 \
    https://www.youtube.com/watch?v=1t1OL2zN0LQ

```

## List youtube playlist

```bash
youtube-dl -j --flat-playlist \
    --proxy socks5://127.0.0.1:1080 \
    'https://www.youtube.com/watch?v=QsBT5EQt348&list=PLFs4vir_WsTySi9F8v5pvCi6zQj7Cwneu' |
    jq '{URL: ("https://www.youtube.com/watch?v=" + .url), original_title: .title}' |
    jq '. + {category: "Kurzgesagt/Human-Stuff"}' |
    jq -s '.' |
    perl -MYAML -MJSON -0777 -e '$c = <>; print YAML::Dump(decode_json($c))'

```

## parallel youtube-dl


```bash
youtube-dl -j --flat-playlist \
    --proxy socks5://127.0.0.1:1080 \
    'https://www.youtube.com/watch?v=QsBT5EQt348&list=PLFs4vir_WsTySi9F8v5pvCi6zQj7Cwneu' |
    jq -r '"https://www.youtube.com/watch?v=" + .url' \
    > list.txt

cat list.txt |
    parallel -j 3 --progress '
        youtube-dl --proxy socks5://127.0.0.1:1080 --embed-thumbnail --add-metadata {}
    '

``

## Add subtitles to mp4

```bash
ffmpeg \
    -i How_to_Solve_the_Rubik_s_Cube_-_An_Easy_Tutorial.mp4 \
    -f srt \
    -i How_to_Solve_the_Rubik_s_Cube_-_An_Easy_Tutorial.en.srt \
    -map 0:0 -map 0:1 -map 1:0 -c:v copy -c:a copy \
    -c:s mov_text \
    How_to_Solve_the_Rubik_s_Cube.mp4

```

## 中英文中间加空格

```perl5
m/[\u4e00-\u9fa5]/; # 中文

s/([\u4e00-\u9fa5])([\w$\\}])/$1 $2/g;
s/([\w$\\}])([\u4e00-\u9fa5])/$1 $2/g;

````

## sha1 sum

```bash
openssl sha1 ~/Documents/1024SecUpd2003-03-03.dmg
```

`sha256` need a newer version of openssl

```bash
openssl version # OpenSSL 0.9.8zh 14 Jan 2016

brew install openssl
/usr/local/opt/openssl/bin/openssl version # OpenSSL 1.0.2j  26 Sep 2016
```

## Random numbers with openssl

```bash
openssl rand 3 | od -DAn
```

## Extract bash codes from this markdown file.

```bash
echo '#!/usr/bin/env bash' > file.md.sh

cat file.md \
    | perl -e '
        @lines = <>;
        $content = join "", @lines;
        while ($content =~ /^`{3,}bash\s*\n(.*?)^`{3,}\s*\n/msg) {
            printf "%s\n", $1;
        }
    ' \
    >> file.md.sh
```

## Show ignored files in git

http://stackoverflow.com/questions/466764/show-ignored-files-in-git

```bash
git ls-files --others -i --exclude-standard
```

## 使用 `netcat` 与 `tar` 传送文件

`nc` is the BSD version of `netcat`. `pv` is a pipe viewer.

```bash
nc -l -p 7777 | pv | tar -x             # on the destination machine

tar -c . | pv | nc wq.nju.edu.cn 7777   # on the source machine
```

## 列出 ssh 支持的加密方式

```shell
# local
ssh -Q cipher

# remote
nmap --script ssh2-enum-algos -sV -p 22 202.119.37.251

```

## 使用 `rsync` 传送文件

* rsync

    * -a: archive mode - rescursive, preserves owner, preserves permissions, preserves modification times, preserves group, copies symlinks as symlinks, preserves device files.
    * -v: increase verbosity
    * -P: show progress during transfer

* ssh

    * -T: turn off pseudo-tty to decrease cpu load on destination.
    * -c arcfour: use the weakest but fastest SSH encryption. Must specify "Ciphers arcfour" in sshd_config on destination.
    * -o Compression=no: Turn off SSH compression.
    * -x: turn off X forwarding if it is on by default.

前一个目录后要跟上 `/`, 后一个不要.

```bash
rsync -avP -e "ssh -T -c chacha20-poly1305@openssh.com -o Compression=no -x" ~/data/anchr/col_0/3_pacbio/ wangq@wq.nju.edu.cn:data/anchr/col_0/3_pacbio
```

## ssh-copy-id

```bash
ssh-keygen -b 2048 -t rsa -q
ssh-copy-id -i ~/.ssh/id_rsa.pub wangq@202.119.37.251
```

## 使用 Windows 下的 `.ssh`

```shell
cp -R /mnt/c/Users/wangq/.ssh/ ~/

chmod 700 ~/.ssh
chmod 600 ~/.ssh/id_rsa
chmod 600 ~/.ssh/id_rsa.pub

```

## `htop`

```shell
ssh c55n08 -t 'htop'

```

## 去掉 PDF 中的水印

```bash
cat Graphing\ Data\ with\ R.pdf | grep -v "it\-ebooks" > Graphing_Data_with_R.pdf
```

用Acrobat打开并保存.

## valgrind

```bash
valgrind --tool=memcheck --leak-check=full --track-fds=yes ./faops
```

# Mac

## 修改 macOS 系统的 hostname

```bash
sudo scutil --set HostName yourname
```

## ssh-copy-id

https://github.com/beautifulcode/ssh-copy-id-for-OSX

## dos2unix

```bash
find . -type f  -not -iname ".*" -not -path "*.git*" \
    | parallel -j 1 "perl -pi -e 's/\r\n|\n|\r/\n/g' {}"
```

## Make Hidden Apps “Hidden” in Dock

⌘H (hide app)

```bash
defaults write com.apple.Dock showhidden -bool TRUE; killall Dock
```

## 设置终端的 Title

http://superuser.com/questions/223308/name-terminal-tabs

Note that "0" sets both the window and the tab title. As of Mac OS X Lion 10.7, you can set them
independently, using "1" (tab title) and "2" (window title).

```bash
echo -n -e "\033]0;In soviet russia, the title bar sets you\007"
```

## A blank line at the very bottom of terminal tabs

https://apple.stackexchange.com/questions/305462/terminal-leaving-a-blank-line-on-high-sierra-when-tabs-are-used

## 将 HOME 目录移动它其它硬盘

https://www.lifewire.com/move-macs-home-folder-new-location-2260157

## 制作 High Sierra 安装盘

```bash
sudo /Applications/Install\ macOS\ High\ Sierra.app/Contents/Resources/createinstallmedia \
    --volume /Volumes/Untitled/ \
    --applicationpath /Applications/Install\ macOS\ High\ Sierra.app/ \
    --nointeraction

```

## 稍微平滑字体

默认值是 0 或 2

```bash
defaults write -g AppleFontSmoothing -int 1
sudo defaults write -g AppleFontSmoothing -int 1
```

## Beyond Compare 4 for Mac 无限试用版

```bash
rm "${HOME}/Library/Application Support/Beyond Compare/registry.dat"
```

## Local Backup

因为你把Time Machine打开但太久没有把备份硬盘插回去导致的, 他会继续备份然后储存在本机 等你接上备份硬盘再传过去.

永远不要用这个功能的话就在终端机输入`sudo tmutil disablelocal`

要回复成原厂设定就输入`sudo tmutil enablelocal`

## 拼写检查

* Navigate to the Applications folder and open Terminal.
* Enter `open ~/Library/Spelling/` and press Return.
* This will open a Finder window. The file LocalDictionary contains the dictionary your Mac uses for
  spell checking.

## 英文界面 Mac 使用中文界面 Office 的方法

```bash
defaults write $(mdls -name kMDItemCFBundleIdentifier -raw '/Applications/Microsoft Word.app')  AppleLanguages "(zh-Hans, zh_CN, zh, en)"
defaults write $(mdls -name kMDItemCFBundleIdentifier -raw '/Applications/Microsoft Excel.app') AppleLanguages "(zh-Hans, zh_CN, zh, en)"
defaults write $(mdls -name kMDItemCFBundleIdentifier -raw '/Applications/Microsoft PowerPoint.app') AppleLanguages "(zh-Hans, zh_CN, zh, en)"
```

## RStudio 运行时 console 里 locale 错误

```bash
defaults write org.R-project.R force.LANG en_US.UTF-8
```

## Mission control animations

http://apple.stackexchange.com/questions/66433/remove-shift-key-augmentation-for-mission-control-animation

## Disconnect ethernet adaptor

```bash
sudo /sbin/ifconfig en0 down
```

Bring it back

```bash
sudo /sbin/ifconfig en0 up
```

## Add public key to github

http://stackoverflow.com/questions/8402281/github-push-error-permission-denied

## Change the default app that opens all the files of one particular file type.

1. Select the file
2. CMD-I (Get Info)
3. Under Open With pick the app that you want to become the default
4. Click the Change All button
5. Confirm your decision

## 鼠标加速

```shell
defaults write .GlobalPreferences com.apple.mouse.scaling -1

```

## 禁止深度睡眠

1. `sudo pmset -a hibernatemode 0`
2. Reboot
3. Remove `/private/var/vm/sleepimage` if present.

## 下载的 App

> The App is damaged

`sudo spctl --master-disable`

## 微调音量

按 `Option` + `Shift` + `Volume Up/Volume Down`, 以四分之一格调整音量.

http://apple.stackexchange.com/questions/63253/lowest-volume-is-still-too-loud-how-can-i-make-it-even-lower

## Inkscape

https://bugs.launchpad.net/inkscape/+bug/1218578

在命令行中使用包装过的脚本而不是 `inkscape-bin`, 同时输入输出都使用绝对路径.

```bash
/Applications/Inkscape.app/Contents/Resources/script -f /path/to/drawing.svg --export-png=/path/to/export/drawing.png
```

Inkscape 支持标准输入输出, 但要使用 `/dev/stdout` 来代替更常用的
`-`，但在如上面说的，macOS里又要使用绝对路径，所以用`/dev/fd/1`.

```bash
/Applications/Inkscape.app/Contents/Resources/script \
    ~/Downloads/textextract-good.pdf \
    --export-plain-svg /dev/fd/1 |
    xmllint --format - \
    > ~/Downloads/textextract-good.svg
```

如 [APUE](http://www.informit.com/articles/article.aspx?p=99706&seqNum=15) 里所说：

> Some systems provide the pathnames /dev/stdin, /dev/stdout, and /dev/stderr. These pathnames are
> equivalent to /dev/fd/0, /dev/fd/1, and /dev/fd/2.

## librsvg

简单的 SVG 可以使用 `rsvg-converter` 来转换

```bash
rsvg-convert ~/Scripts/alignDB/doc/alignDB.svg -z 2 -f png -o ~/Scripts/alignDB/doc/alignDB.png
```

# Ubuntu

## how to install arial font in ubuntu

```
sudo apt-get -y update
sudo apt-get -y install ttf-mscorefonts-installer
sudo fc-cache -fsv
```

## `build-dep`

```shell
sudo apt build-dep <packagename>

sudo apt install apt-rdepends
apt-rdepends --build-depends --print-state --follow=DEPENDS <packagename>
```

## ssh for ubuntu-desktop

```bash
sudo apt-get install -y openssh-server
sudo apt-get install -y net-tools
sudo vi /etc/ssh/sshd_config
sudo /etc/init.d/ssh restart
```

## vnc for ubuntu-desktop

http://askubuntu.com/questions/518041/unity-doesnt-work-on-vnc-server-under-14-04-lts

```bash
sudo apt-get -y update
sudo apt-get -y install tightvncserver
sudo apt-get -y install gnome-panel gnome-settings-daemon metacity nautilus gnome-terminal
```

Create a customized `~/.vnc/xstartup`.

```bash
mkdir -p ~/.vnc

cat <<EOF > ~/.vnc/xstartup
#!/bin/sh

export XKL_XMODMAP_DISABLE=1
unset SESSION_MANAGER
unset DBUS_SESSION_BUS_ADDRESS

[ -x /etc/vnc/xstartup ] && exec /etc/vnc/xstartup
[ -r $HOME/.Xresources ] && xrdb $HOME/.Xresources
xsetroot -solid grey
vncconfig -iconic &

gnome-panel &
gnome-settings-daemon &
metacity &
nautilus &
gnome-terminal &

EOF

```

Customized resolution.

```bash
vncserver -geometry 1200x900
```

## Install desktop for ubuntu-server

```bash
# sudo apt-get install --no-install-recommends ubuntu-desktop
```

## Remove libreoffice from ubuntu-desktop

```bash
sudo apt-get remove --purge libreoffice*
sudo apt-get clean
sudo apt-get autoremove
```

## lvm

```bash
sudo apt-get install gparted
sudo apt-get install system-config-lvm
```

http://www.howtogeek.com/127246/linux-sysadmin-how-to-manage-lvms-with-a-gui/

## Checking your Ubuntu Version

```bash
lsb_release -a

```

## Kernel version

```shell
uname -srm

```


## virtualbox

```bash
sudo apt-get install virtualbox-guest-dkms virtualbox-guest-utils virtualbox-guest-x11
```

## List all desktop applications

http://askubuntu.com/questions/433609/how-can-i-list-all-applications-installed-in-my-system

```bash
for app in /usr/share/applications/*.desktop ~/.local/share/applications/*.desktop; do
    app="${app##/*/}";
    echo "${app::-8}";
done

```

## Change hostname

```bash
hostnamectl set-hostname new-hostname
```

## create a sudoer user

```bash
sudo adduser wangq
sudo adduser wangq users
sudo adduser wangq sudo
```

## delete a user

```bash
sudo deluser --remove-home newuser
```

## use root account

Switch to root account with `su` command to set root account's password.

```bash
sudo passwd root
su -
```

## kernel upgrade broke vbox

http://askubuntu.com/questions/289335/kernel-update-breaks-oracle-virtual-box-frequently-how-do-i-avoid-this

```bash
/etc/init.d/vboxdrv setup
```

## socks proxy for apt

When GFW going on a rampage, let apt use host's shadowsocks

```bash
sudo vim /etc/apt/apt.conf
Acquire::socks::proxy "socks5://10.0.1.5:1080/";
```

## mongodb from apt-get

http://docs.mongodb.org/manual/tutorial/install-mongodb-on-ubuntu/

```bash
sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 7F0CEB10
echo "deb http://repo.mongodb.org/apt/ubuntu "$(lsb_release -sc)"/mongodb-org/3.0 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-3.0.list
sudo apt-get -y update
sudo apt-get install -y mongodb-org
```

## search for a package

```bash
apt-cache search PACKAGE_NAME
apt-cache show PACKAGE_NAME
```

## Disk usages

```bash
df -BG
```

## Docker VPN

* Install Docker

```bash
# Recommended extra packages for Trusty 14.04
sudo apt-get update -y
sudo apt-get install -y --no-install-recommends linux-image-extra-virtual
sudo apt-get install -y --no-install-recommends linux-image-extra-$(uname -r)

# Set up the repository
sudo apt-get install -y --no-install-recommends \
    apt-transport-https \
    ca-certificates \
    curl \
    software-properties-common

curl -fsSL https://apt.dockerproject.org/gpg | sudo apt-key add -
apt-key fingerprint 58118E89F3A912897C070ADBF76221572C52609D

sudo add-apt-repository \
    "deb https://apt.dockerproject.org/repo/ \
    ubuntu-$(lsb_release -cs) \
    main"

# Install Docker
sudo apt-get update
sudo apt-get -y install docker-engine
sudo docker run hello-world
```

* VPN

    as root

```bash
docker run --privileged -d --name ikev2-vpn-server \
    --restart=always -p 500:500/udp -p 4500:4500/udp gaomd/ikev2-vpn-server:0.3.0

docker run --privileged -i -t --rm --volumes-from ikev2-vpn-server \
    -e "HOST=$(hostname -I | cut -d\  -f1)" gaomd/ikev2-vpn-server:0.3.0 generate-mobileconfig \
    > ikev2-vpn.mobileconfig
```

## 查看内存类型

```bash
sudo dmidecode --type 17 | less
```

# WSL

## 减少空间占用

* 找到虚拟磁盘位置

```powershell
Get-AppxPackage -Name "*Ubuntu*" | Select PackageFamilyName

explorer.exe $env:LOCALAPPDATA\Packages\<PackageFamilyName>\LocalState\

```

* https://github.com/microsoft/WSL/issues/4699#issuecomment-627133168

```powershell
wsl --shutdown

diskpart
# open window Diskpart
select vdisk file="C:\Users\wangq\AppData\Local\Packages\CanonicalGroupLimited.Ubuntu20.04onWindows_79rhkp1fndgsc\LocalState"
attach vdisk readonly
compact vdisk
detach vdisk
exit

```
