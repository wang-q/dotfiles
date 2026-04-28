# Setting-up scripts for Ubuntu

[TOC levels=2-3]: # ""

- [Install packages needed by Linuxbrew and some others](#install-packages-needed-by-linuxbrew-and-some-others)
- [Optional: adjusting Desktop](#optional-adjusting-desktop)
- [Install Linuxbrew](#install-linuxbrew)
- [Install packages managed by Linuxbrew](#install-packages-managed-by-linuxbrew)
- [Packages of each language](#packages-of-each-language)
- [Bioinformatics Apps](#bioinformatics-apps)
- [MySQL](#mysql)
- [Optional: dotfiles](#optional-dotfiles)
- [Directory Organization](#directory-organization)

The whole developing environment is based on [Linuxbrew](http:s//linuxbrew.sh/). Many of the
following steps also work under macOS via [Homebrew](https://brew.sh/).

## Install packages needed by Linuxbrew and some others

```shell script
echo "==> When some packages went wrong, check http://mirrors.ustc.edu.cn/ubuntu/ for updating status."
bash -c "$(curl -fsSL https://raw.githubusercontent.com/wang-q/dotfiles/master/linux/1-apt.sh)"

```

## Optional: adjusting Desktop

In GUI desktop, disable auto updates: `Software & updates -> Updates`,
set `Automatically check for updates` to `Never`, untick all checkboxes, click close and click close
again.

```shell script
# Removes nautilus bookmarks and disables lock screen
echo '==> `Ctrl+Alt+T` to start a GUI terminal'
curl -fsSL https://raw.githubusercontent.com/wang-q/dotfiles/master/linux/2-gnome.sh |
    bash

```

## Install Linuxbrew

使用清华的[镜像](https://mirrors.tuna.tsinghua.edu.cn/help/homebrew/).

```shell
# curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh -O
# bash install.sh
#
# (echo; echo 'eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"') >> /home/wangq/.bashrc

echo "==> Tuna mirrors of Homebrew/Linuxbrew"
export HOMEBREW_BREW_GIT_REMOTE="https://mirrors.tuna.tsinghua.edu.cn/git/homebrew/brew.git"
export HOMEBREW_CORE_GIT_REMOTE="https://mirrors.tuna.tsinghua.edu.cn/git/homebrew/homebrew-core.git"

git clone --depth=1 https://mirrors.tuna.tsinghua.edu.cn/git/homebrew/install.git brew-install
/bin/bash brew-install/install.sh

rm -rf brew-install

test -d ~/.linuxbrew && PATH="$HOME/.linuxbrew/bin:$HOME/.linuxbrew/sbin:$PATH"
test -d /home/linuxbrew/.linuxbrew && PATH="/home/linuxbrew/.linuxbrew/bin:/home/linuxbrew/.linuxbrew/sbin:$PATH"

if grep -q -i Homebrew $HOME/.bashrc; then
    echo "==> .bashrc already contains Homebrew"
else
    echo "==> Update .bashrc"

    echo >> $HOME/.bashrc
    echo '# Homebrew' >> $HOME/.bashrc
    echo "export PATH='$(brew --prefix)/bin:$(brew --prefix)/sbin'":'"$PATH"' >> $HOME/.bashrc
    echo "export MANPATH='$(brew --prefix)/share/man'":'"$MANPATH"' >> $HOME/.bashrc
    echo "export INFOPATH='$(brew --prefix)/share/info'":'"$INFOPATH"' >> $HOME/.bashrc
    echo "export HOMEBREW_NO_ANALYTICS=1" >> $HOME/.bashrc
    echo "export HOMEBREW_NO_AUTO_UPDATE=1" >> $HOME/.bashrc
    echo 'export HOMEBREW_BREW_GIT_REMOTE="https://mirrors.tuna.tsinghua.edu.cn/git/homebrew/brew.git"' >> $HOME/.bashrc
    echo 'export HOMEBREW_CORE_GIT_REMOTE="https://mirrors.tuna.tsinghua.edu.cn/git/homebrew/homebrew-core.git"' >> $HOME/.bashrc
    echo 'export HOMEBREW_API_DOMAIN="https://mirrors.tuna.tsinghua.edu.cn/homebrew-bottles/api"' >> $HOME/.bashrc
    echo 'export HOMEBREW_BOTTLE_DOMAIN="https://mirrors.tuna.tsinghua.edu.cn/homebrew-bottles"' >> $HOME/.bashrc
    echo >> $HOME/.bashrc
fi

source $HOME/.bashrc

```

## Packages of each language

```shell script
mkdir -p $HOME/Scripts/
git clone https://github.com/wang-q/dotfiles.git $HOME/Scripts/dotfiles

bash $HOME/Scripts/dotfiles/perl/install.sh

bash $HOME/Scripts/dotfiles/python/install.sh

bash $HOME/Scripts/dotfiles/r/install.sh

# Optional
# bash $HOME/Scripts/dotfiles/rust/install.sh

```

## cbp

```bash script
curl -LO https://github.com/wang-q/cbp/releases/latest/download/cbp.linux
chmod +x cbp.linux
./cbp.linux init --dev
source ~/.bashrc

```

## Bioinformatics Apps

```shell script
bash $HOME/Scripts/dotfiles/genomics.sh

# bash $HOME/Scripts/dotfiles/perl/ensembl.sh

# Optional: huge apps
# bash $HOME/Scripts/dotfiles/others.sh

```
