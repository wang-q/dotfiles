#!/bin/bash

# mpv
brew install duti mvtools ffms2
brew reinstall --with-vapoursynth --with-bundle mpv
brew linkapps mpv

# casks
brew tap caskroom/cask

# system
brew cask install alfred caffeine disk-inventory-x hammerspoon scroll-reverser

# utils
brew cask install calibre free-download-manager netspot utorrent xmind

# media
brew cask install aegisub handbrake iina

# sci
brew cask install dendroscope figtree jabref

# development
brew cask install mysqlworkbench robomongo sourcetree

# 163
brew cask install neteasemusic youdaodict youdaonote

# fonts
brew tap caskroom/fonts
brew cask install font-fira-sans font-fira-mono font-charter
