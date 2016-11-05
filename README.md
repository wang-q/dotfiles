# My configuration files on macOS

![Screenshot of a terminal window](images/screen.png)

## Configurations managed by GNU stow

* `bash install.sh`
* [ack](stow-ack/.ackrc)
* [bash](stow-bash/)
* [git](stow-git/)
* [perltidy](stow-perltidy/.perltidyrc)
* [proxychains](stow-proxychains/)
* [GNU screen](stow-screen/.screenrc)
* [vim](stow-vim/.vimrc)
* [vimperator](stow-vimperator/.vimperatorrc)
* [wget](stow-wget/.wgetrc)

## macOS and Ubuntu

* [`brew.sh`](brew.sh)
    * Install CLI apps via Homebrew

* [`genomics.sh`](genomics.sh)
    * Install bioinformatics apps via Homebrew science and my own tap
    * Trinity, GATK and picard

* [r](r/)
    * `bash r/install.sh`

* vim plugins
    * `git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim`
    * `vim +PluginInstall +qall`

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
