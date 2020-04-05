# Install TexLive

## TexLive and companions

```bash
brew cask install mactex-no-gui

tex --version
tlmgr --version

brew install pandoc imagemagick gifsicle

# Optional
brew cask install jabref

```

## `tlmgr`

```bash
sudo tlmgr option repository https://mirrors.ustc.edu.cn/CTAN/systems/texlive/tlnet/

sudo tlmgr update --self
sudo tlmgr update --all

# tex utils
# sudo tlmgr install latexmk
# sudo tlmgr install pdfjam
# sudo tlmgr install collection-binextra # arara, pdfcrop
# sudo tlmgr install collection-latexextra # standalone

# beamer template
sudo tlmgr install beamertheme-metropolis

# Some TeX packages
# sudo tlmgr install tools # calc
# sudo tlmgr install xecjk
# sudo tlmgr install pgf # TikZ pgfpages
# sudo tlmgr install graphics
# sudo tlmgr install caption # subcaption
# sudo tlmgr install animate
# sudo tlmgr install mhchem
# sudo tlmgr install biblatex
# sudo tlmgr install hyperref

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

fc-cache -fsv

```
