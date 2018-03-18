#!/bin/bash

# mpv
brew install duti mvtools ffms2
brew reinstall --with-vapoursynth --with-bundle mpv
brew linkapps mpv

# casks
brew tap caskroom/cask

# utils
brew cask install alfred caffeine disk-inventory-x hammerspoon scroll-reverser
brew cask install free-download-manager netspot utorrent xmind

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
brew cask install font-fira-sans
brew cask install font-fira-mono
brew cask install font-charter
