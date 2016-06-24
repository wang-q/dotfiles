# [MSYS2](http://msys2.github.io/)

## install

1. Download [msys2 installer](http://mirrors.ustc.edu.cn/msys2/Base/i686/msys2-i686-20150512.exe) and install it.

2. Update the system packages.

    ```bash
    # Start c:\msys32\msys2_shell.bat
    pacman --needed -Sy bash pacman pacman-mirrors msys2-runtime
    ```

3. 编辑 /etc/pacman.d/下的三个镜像列表文件，加入[中科大源](https://lug.ustc.edu.cn/wiki/mirrors/help/msys2).

    ```bash
    # Restart c:\msys32\msys2_shell.bat
    sed -i '1s/^/Server = http:\/\/mirrors.ustc.edu.cn\/msys2\/REPOS\/MINGW\/i686\n/' /etc/pacman.d/mirrorlist.mingw32
    sed -i '1s/^/Server = http:\/\/mirrors.ustc.edu.cn\/msys2\/REPOS\/MINGW\/x86_64\n/' /etc/pacman.d/mirrorlist.mingw64
    sed -i '1s/^/Server = http:\/\/mirrors.ustc.edu.cn\/msys2\/REPOS\/MSYS2\/\$arch\n/' /etc/pacman.d/mirrorlist.msys

    pacman -Syu
    ```
4. Other packages.

    ```bash
    # msys itself
    pacman -S base-devel
    pacman -S msys2-devel
    pacman -S xz zip unzip rsync git

    # 32bit mingw
    # pacman -S mingw32/mingw-w64-i686-toolchain

    # gtk3
    pacman -S mingw32/mingw-w64-i686-gtk3
    pacman -S mingw32/mingw-w64-i686-gobject-introspection

    # others
    # pacman -S mingw32/mingw-w64-i686-imagemagick

    # fix .pc files
    find /mingw32/lib/pkgconfig -name "*.pc" \
        | sort \
        | xargs perl -i -nlp -e '/^prefix/ and $_ = q{prefix=${pcfiledir}/../..}; /msys64/ and s/msys64/msys32/g'
    ```

## Pacman常用命令

### 列出所有安装包

`pacman -Sl`

### 搜索安装包

`pacman -Ss 安装包名称`

`pacman -Sl | grep 安装包名称`

### 卸载安装包

* 删除单个软件包，保留其全部已经安装的依赖关系

    `pacman -R 安装包名称`

* 删除指定软件包，及其所有没有被其他已安装软件包使用的依赖关系

    `pacman -Rs 安装包名称`

* 要删除软件包和所有依赖这个软件包的程序

    `pacman -Rsc 安装包名称`

### 查看安装包

* 特定软件包

    `pacman -Q 安装包名称`

* 列出所有已安装的软件包

    `pacman -Q`

### 升级

* 更新软件包数据库

    `pacman -Sy`

* 升级系统

    `pacman -Su`

### 清理缓存

* 仅在确定当前安装的软件包足够稳定且不需要降级时才执行清理。旧版本的软件包能在系统更新崩溃时派上用场

    `pacman -Sc`

* 清理所有缓存，但这样 pacman 在重装软件包时就只能重新下载了。除非空间不足，否则不应这么做

    `pacman -Scc`
