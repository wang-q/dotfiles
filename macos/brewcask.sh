#!/bin/bash

# Quick look
# https://github.com/sindresorhus/quick-look-plugins
xattr -r ~/Library/QuickLook
xattr -d -r com.apple.quarantine ~/Library/QuickLook

brew install --cask qlstephen # Preview plain text files
xattr -cr ~/Library/QuickLook/QLStephen.qlgenerator
qlmanage -r
qlmanage -r cache

# mas - Mac App Store command-line interface
brew install mas

# development
brew install --cask github
brew install --cask visual-studio-code
brew install --cask rstudio

# utils
brew install --cask caffeine
brew install --cask maczip
brew install --cask hammerspoon
brew install --cask scroll-reverser
brew install --cask qbittorrent
brew install --cask disk-inventory-x
mas install 425264550 # Disk Speed Test (3.2)

# media
brew install --cask iina
brew install --cask handbrake
# sci
brew install --cask dendroscope figtree jabref

# apps
mas install 1327661892  # Xmind：思维导图
mas install 451108668 # QQ
mas install 836500024 # WeChat

mas install 880001334 # Reeder (3.2.3)
mas install 1344409961 # BeyondcowTXTReader (1.9.6)
