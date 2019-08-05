# My configuration files on macOS

![Screenshot of a terminal window](images/screen.png)

## Configurations managed by GNU stow

* `bash install.sh`
* [ack](stow-ack/)
* [bash](stow-bash/)
* [htop](stow-htop/)
* [git](stow-git/)
* [perltidy](stow-perltidy/)
* [proxychains](stow-proxychains/)
* [GNU screen](stow-screen/)
* [vim](stow-vim/)
* [wget](stow-wget/)

## macOS and Ubuntu

* [`brew.sh`](brew.sh)
    * Install CLI apps via Homebrew/Linuxbrew

* [`perl`](perl/)
    * `bash perl/install.sh`

* [`python`](python/)
    * `bash python/install.sh`

* [`r`](r/)
    * `bash r/install.sh`

* Vim plugins
    * `git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim`
    * `vim +PluginInstall +qall`

* Bioinformatics
    * [`download.sh`](download.sh)
        * My repos, jkbin and circos
    * [`genomics.sh`](genomics.sh)
        * Install apps from brewsci and my own homebrew-tap
    * [`others.sh`](genomics.sh)
        * Install Trinity, GATK and interproscan manually

## macOS only

* [`macos.sh`](macos.sh)
    * Extracted from [Mathias’s dotfiles](https://github.com/mathiasbynens/dotfiles/blob/master/.macos)

* [`brewcask.sh`](brewcask.sh)
    * Install GUI apps via Homebrew Cask
    * install Fira fonts via Homebrew Cask fonts

* [Hammerspoon](hammerspoon/)
    * Lua powered Mac window manager
    * `bash hammerspoon/install.sh`

* [mpv](mpv/)
    * Video player I choose.
    * `bash mpv/install.sh`
