#!/bin/bash

# https://www.reddit.com/r/osx/comments/4ljbdq/mpv_tutorial_and_60_fps_playback_on_os_x/
# ffmpeg
brew install lame libvo-aacenc x264 xvid fdk-aac
brew install --without-harfbuzz libass
brew install --with-x265 --with-theora --with-rtmpdump --with-openssl \
    --with-libvorbis --with-libass --with-libbs2b --with-rubberband --with-fdk-aac \
    ffmpeg

# mpv
brew install duti mvtools ffms2
brew reinstall --with-vapoursynth --with-bundle mpv

# casks
brew tap caskroom/cask
brew tap caskroom/versions

# system
brew cask install alfred caffeine disk-inventory-x hammerspoon scroll-reverser

# utils
brew cask install calibre free-download-manager netspot utorrent xmind

# media
brew cask install aegisub handbrake iina

# sci
brew cask install dendroscope figtree jabref

# development
brew cask install mysqlworkbench robo-3t sourcetree mongodb-compass

# 163
brew cask install neteasemusic youdaodict youdaonote

# versions
brew cask install microsoft-remote-desktop-beta

# fonts
brew tap caskroom/fonts
brew cask install font-fira-sans font-fira-mono font-charter
