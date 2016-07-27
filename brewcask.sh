#!/bin/bash

# mpv
brew install duti
brew install mvtools
brew install ffms2
brew install subliminal
brew reinstall --with-vapoursynth --with-bundle mpv
brew linkapps mpv

# casks
brew tap caskroom/cask
brew cask install aegisub caffeine disk-inventory-x hammerspoon jabref
brew cask install packer robomongo scroll-reverser sourcetree xmind
brew cask install figtree dendroscope
