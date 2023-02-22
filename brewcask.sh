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
brew install --cask jetbrains-toolbox
brew install --cask mysqlworkbench mongodb-compass robo-3t
brew install --cask rstudio

# utils
brew install --cask caffeine
brew install --cask maczip
brew install --cask hammerspoon
brew install --cask scroll-reverser
brew install --cask qbittorrent
brew install --cask disk-inventory-x
brew install --cask calibre
mas install 425264550 # Disk Speed Test (3.2)
# brew install --cask microsoft-remote-desktop
#netspot OnyX Shottr 

# media
brew install --cask mpv
brew install --cask iina
brew install --cask aegisub
brew install --cask handbrake
mas install 1012296988 # 爱奇艺 (5.17.6)
mas install 944848654 # NeteaseMusic (2.3.2)

# sci
brew install --cask dendroscope figtree jabref mathpix-snipping-tool

# apps
mas install 1327661892  # Xmind：思维导图
mas install 451108668 # QQ
mas install 836500024 # WeChat
mas install 803453959 # Slack
mas install 1435447041 # DingTalk

mas install 491854842 # YoudaoDict (2.7.0)
mas install 880001334 # Reeder (3.2.3)
mas install 1243368435 # 讯飞语音输入 (1.1.1224)
mas install 1344409961 # BeyondcowTXTReader (1.9.6)
