# Install TexLive

## TexLive and companions

```bash
brew cask install mactex-no-gui

tex --version
tlmgr --version

brew install pandoc imagemagick gifsicle

# Optional
brew cask install jabref

# 
brew install texlive
tlmgr --verify-repo=none install scheme-medium

```

## `tlmgr`

```bash
tlmgr option repository https://mirrors.nju.edu.cn/CTAN/systems/texlive/tlnet/

tlmgr update --self --all
tlmgr path add
fmtutil-sys --all

# tlmgr search --global --file "/times.sty"

tlmgr install latexmk pdfjam pdfcrop arara
tlmgr install psnfss
tlmgr install standalone
tlmgr install was # upgreek
tlmgr install xltxtra
tlmgr install realscripts
tlmgr install xecjk
tlmgr install mhchem
tlmgr install biblatex
tlmgr install animate
tlmgr install pgf pgfplots
tlmgr install zref
tlmgr install media9 ocgx2 xcolor

# beamer template
sudo tlmgr install beamertheme-metropolis

```

## Fonts

```bash
brew tap homebrew/cask-fonts

brew cask install font-fira-sans
brew cask install font-fira-mono
brew cask install font-charter

brew cask install font-noto-emoji

brew cask install font-source-sans-pro
brew cask install font-source-serif-pro
brew cask install font-source-code-pro

brew cask install font-source-han-sans
brew cask install font-source-han-serif
brew cask install font-source-han-mono

# brew cask install colindean/fonts-nonfree/font-microsoft-office

# https://github.com/mozilla/Fira/archive/4.202.tar.gz

fc-cache -fsv

```
