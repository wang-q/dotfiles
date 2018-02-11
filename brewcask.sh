#!/bin/bash

# mpv
brew install duti mvtools ffms2
brew reinstall --with-vapoursynth --with-bundle mpv
brew linkapps mpv

# casks
brew tap caskroom/cask

# utils
brew cask install alfred caffeine disk-inventory-x hammerspoon scroll-reverser
brew cask install free-download-manager xmind

# media
brew cask install aegisub iina

# sci
brew cask install jabref figtree dendroscope

# development
brew cask install mysqlworkbench robomongo

# 163
brew cask install youdaodict youdaonote neteasemusic

# fonts
brew tap caskroom/fonts
brew cask install font-fira-sans
brew cask install font-fira-mono
brew cask install font-charter
