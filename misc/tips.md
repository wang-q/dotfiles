# Common

## 用screen启动几个常用后台程序

```bash
screen -dmS op
screen -S op -x -X screen perl -MPod::POM::Web -e "server 8888"
rm ~/share/mongodb/data/mongod.lock
screen -S op -x -X screen ~/share/mongodb/bin/mongod --config ~/share/mongodb/mongod.cnf

# screen -S op -x -X screen numactl --interleave=all ~/share/mongodb/bin/mongod --config ~/share/mongodb/mongod.cnf

# On OSX, use `launchctl`
screen -S op -x -X screen redis-server
screen -S op -x -X screen ~/share/mysql/bin/mysqld_safe
```

## 列出所有子目录的git状态

Ideas from this [SO post](http://stackoverflow.com/questions/3497123/run-git-pull-over-all-subdirectories).

* Status of all repos

```bash
find ~/Scripts -type d -mindepth 1 -maxdepth 3 -name ".git" \
    | sort \
    | parallel -r -k -j 1 \
    "echo {//}; git -C {//} status; echo ===="
```

* Only show repos needing attentions

```bash
find ~/Scripts -type d -mindepth 1 -maxdepth 3 -name ".git" \
    | sort \
    | parallel -r -k -j 1 \
        "echo {//}; git -C {//} status; echo ====" \
    | perl -e '
        @lines = <>;
        @sections = split /\=+/, join("", @lines);
        print "\n==> Behind\n";
        print for grep {/Your branch is behind/} @sections;
        print "\n==> Ahead\n";
        print for grep {/Your branch is ahead/} @sections;
        print "\n==> Not staged\n";
        print for grep {/Changes not staged for commit/} @sections;
        print "\n==> Untrack\n";
        print for grep {/Untracked files/} @sections;'

```

## sha1 sum

```bash
openssl sha1 ~/Documents/1024SecUpd2003-03-03.dmg
```

sha256 need newer version of openssl

```bash
openssl version # OpenSSL 0.9.8zh 14 Jan 2016

brew install openssl
/usr/local/opt/openssl/bin/openssl version # OpenSSL 1.0.2j  26 Sep 2016
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

## 去掉PDF中的水印

```bash
cat Graphing\ Data\ with\ R.pdf | grep -v "it\-ebooks" > Graphing_Data_with_R.pdf
```

用Acrobat打开并保存.

## valgrind

```bash
valgrind --tool=memcheck --leak-check=full --track-fds=yes ./faops
```

# Mac

## 修改mac osx系统的hostname

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

## 设置终端的Title

http://superuser.com/questions/223308/name-terminal-tabs

Note that "0" sets both the window and the tab title. As of Mac OS X Lion 10.7, you can set them independently, using "1" (tab title) and "2" (window title).

```bash
echo -n -e "\033]0;In soviet russia, the title bar sets you\007"
```

## Local Backup

因为你把Time Machine打开但太久没有把备份硬盘插回去导致的, 他会继续备份然后储存在本机 等你接上备份硬盘再传过去.

永远不要用这个功能的话就在终端机输入`sudo tmutil disablelocal`

要回复成原厂设定就输入`sudo tmutil enablelocal`

## 拼写检查

* Navigate to the Applications folder and open Terminal.
* Enter `open ~/Library/Spelling/` and press Return.
* This will open a Finder window. The file LocalDictionary contains the dictionary your Mac uses for spell checking.

## 英文界面 Mac 使用中文界面 Office 的方法

```bash
defaults write $(mdls -name kMDItemCFBundleIdentifier -raw '/Applications/Microsoft Word.app')  AppleLanguages "(zh-Hans, zh_CN, zh, en)"
defaults write $(mdls -name kMDItemCFBundleIdentifier -raw '/Applications/Microsoft Excel.app') AppleLanguages "(zh-Hans, zh_CN, zh, en)"
defaults write $(mdls -name kMDItemCFBundleIdentifier -raw '/Applications/Microsoft PowerPoint.app') AppleLanguages "(zh-Hans, zh_CN, zh, en)"
```

## RStudio运行时console里locale错误

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

## 禁止深度睡眠

1. `sudo pmset -a hibernatemode 0`
2. Reboot
3. Remove `/private/var/vm/sleepimage` is present.

## 微调音量

按 `Option` + `Shift` + `Volume Up/Volume Down`, 以四分之一格调整音量.

http://apple.stackexchange.com/questions/63253/lowest-volume-is-still-too-loud-how-can-i-make-it-even-lower

## Inkscape

https://bugs.launchpad.net/inkscape/+bug/1218578

在命令行中使用包装过的脚本而不是 `inkscape-bin`, 同时输入输出都使用绝对路径.

```bash
/Applications/Inkscape.app/Contents/Resources/script -f /path/to/drawing.svg --export-png=/path/to/export/drawing.png
```

Inkscape 支持标准输入输出, 但要使用 `/dev/stdout` 来代替更常用的 `-`，但在如上面说的，macOS里又要使用绝对路径，所以用`/dev/fd/1`.

```bash
 /Applications/Inkscape.app/Contents/Resources/script \
    ~/Downloads/textextract-good.pdf \
    --export-plain-svg /dev/fd/1 \
    | xmllint --format - \
    > ~/Downloads/textextract-good.svg
```

如 [APUE](http://www.informit.com/articles/article.aspx?p=99706&seqNum=15) 里所说：

> Some systems provide the pathnames /dev/stdin, /dev/stdout, and /dev/stderr. These pathnames are equivalent to /dev/fd/0, /dev/fd/1, and /dev/fd/2.

# Ubuntu

## how to install arial font in ubuntu

```
sudo apt-get install ttf-mscorefonts-installer
sudo fc-cache
```

## ssh for ubuntu-desktop

```bash
sudo apt-get install openssh-server
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
```

## Install desktop for ubuntu-server

```bash
# sudo apt-get install --no-install-recommends ubuntu-desktop
```

## Checking your Ubuntu Version

`lsb_release -a`

## virtualbox

```bash
sudo apt-get install virtualbox-guest-dkms virtualbox-guest-utils virtualbox-guest-x11
```

## List all desktop applications

http://askubuntu.com/questions/433609/how-can-i-list-all-applications-installed-in-my-system

```bash
for app in /usr/share/applications/*.desktop ~/.local/share/applications/*.desktop; do app="${app##/*/}"; echo "${app::-8}"; done
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
