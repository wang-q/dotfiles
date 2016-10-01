#!/bin/bash

# mpv
brew install duti mvtools ffms2 subliminal
brew reinstall --with-vapoursynth --with-bundle mpv
brew linkapps mpv

# casks
brew tap caskroom/cask
brew cask install aegisub caffeine disk-inventory-x hammerspoon jabref
brew cask install robomongo scroll-reverser sourcetree xmind
brew cask install figtree dendroscope
