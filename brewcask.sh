#!/bin/bash

# mpv
brew install duti mvtools ffms2
brew reinstall --with-vapoursynth --with-bundle mpv
brew linkapps mpv

# casks
brew tap caskroom/cask
brew cask install caffeine disk-inventory-x hammerspoon  scroll-reverser
brew cask install mysqlworkbench robomongo
brew cask install aegisub jabref xmind
brew cask install figtree dendroscope

# fonts
brew tap caskroom/fonts
brew cask install font-fira-sans
brew cask install font-fira-mono
brew cask install font-charter
