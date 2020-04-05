#!/bin/bash

# https://www.reddit.com/r/osx/comments/4ljbdq/mpv_tutorial_and_60_fps_playback_on_os_x/
# ffmpeg
brew install lame libvo-aacenc libass x264 xvid fdk-aac
brew install ffmpeg

# mpv
brew install duti mvtools ffms2
brew reinstall mpv

# casks
brew tap homebrew/cask-cask
brew tap homebrew/cask-versions

# system
brew cask install alfred caffeine disk-inventory-x ezip hammerspoon scroll-reverser

# utils
brew cask install calibre netspot utorrent xmind

# media
brew cask install aegisub handbrake iina

# sci
brew cask install dendroscope figtree jabref mathpix-snipping-tool

# development
brew cask install mysqlworkbench mongodb-compass robo-3t sourcetree visual-studio-code

# 163
brew cask install neteasemusic youdaodict

# versions
brew cask install microsoft-remote-desktop-beta
