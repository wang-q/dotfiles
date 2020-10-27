#!/bin/bash

# https://www.reddit.com/r/osx/comments/4ljbdq/mpv_tutorial_and_60_fps_playback_on_os_x/
# ffmpeg
brew install lame libvo-aacenc libass x264 xvid fdk-aac
brew install ffmpeg

# mpv
brew install duti mvtools ffms2
brew reinstall mpv

# casks
brew tap homebrew/cask
brew tap homebrew/cask-versions

# system
#brew cask install adoptopenjdk
brew cask install caffeine disk-inventory-x ezip hammerspoon scroll-reverser
#alfred

# utils
brew cask install calibre utorrent xmind
#netspot

# media
brew cask install mpv aegisub handbrake iina

# sci
brew cask install dendroscope figtree jabref mathpix-snipping-tool

# development
brew cask install mysqlworkbench mongodb-compass robo-3t sourcetree visual-studio-code

# 163
brew cask install neteasemusic youdaodict

# versions
brew cask install homebrew/cask-versions/microsoft-remote-desktop-beta

# mas
brew install mas

mas install 425264550 # Disk Speed Test (3.2)
mas install 451108668 # QQ (6.6.2)
mas install 491854842 # YoudaoDict (2.7.0)
mas install 803453959 # Slack (4.4.2)
mas install 836500024 # WeChat (2.3.31)
mas install 880001334 # Reeder (3.2.3)
mas install 944848654 # NeteaseMusic (2.3.2)
mas install 1012296988 # 爱奇艺 (5.17.6)
mas install 1243368435 # 讯飞语音输入 (1.1.1224)
mas install 1344409961 # BeyondcowTXTReader (1.9.6)
mas install 1435447041 # DingTalk (5.0.2)
