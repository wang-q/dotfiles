# My configuration files on macOS

![Screenshot of a terminal window](images/screen.png)

## Configurations managed by GNU stow

* `bash install.sh`
* [ack](stow-ack/.ackrc)
* [bash](stow-bash/)
* [htop](stow-htop/)
* [git](stow-git/)
* [perltidy](stow-perltidy/.perltidyrc)
* [proxychains](stow-proxychains/)
* [GNU screen](stow-screen/.screenrc)
* [vim](stow-vim/.vimrc)
* [wget](stow-wget/.wgetrc)

## macOS and Ubuntu

* [`brew.sh`](brew.sh)
    * Install CLI apps via Homebrew/Linuxbrew

* [`perl`](perl/)
    * `bash perl/install.sh`

* [`python`](python/)
    * `bash python/install.sh`

* [`r`](r/)
    * `bash r/install.sh`

* vim plugins
    * `git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim`
    * `vim +PluginInstall +qall`

* [`genomics.sh`](genomics.sh)
    * Install bioinformatics apps via Homebrew science and my own homebrew-tap
    * Install Trinity, GATK and picard manually

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
