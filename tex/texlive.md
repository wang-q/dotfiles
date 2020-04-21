# Install TexLive by TinyTex

## [TinyTex](https://yihui.org/tinytex/)

```r
install.packages('tinytex')
tinytex::install_tinytex()

pkgs = readLines('https://yihui.name/gh/tinytex/tools/pkgs-yihui.txt')
tinytex::tlmgr_install(pkgs)

```

## Destination

```text
# Linux
tlmgr path remove
rm -r "~/.TinyTeX"

# macOS
tlmgr path remove
rm -r "~/Library/TinyTeX"

# Windows
tlmgr path remove
rd /s /q "%APPDATA%\TinyTeX"

```

## Companions

```bash

brew install pandoc imagemagick gifsicle  

```

```ps1
scoop install pandoc imagemagick gifsicle

scoop cache rm *; scoop uninstall pandoc; scoop install pandoc

```

## `tlmgr`

```bash
tlmgr option repository https://mirrors.nju.edu.cn/CTAN/systems/texlive/tlnet/

tlmgr update --self --all
tlmgr path add
fmtutil-sys --all

# tlmgr search --global --file "/times.sty"

tlmgr install latexmk pdfjam pdfcrop arara latexindent
tlmgr install pdflscape epstopdf-pkg # pdfjam
tlmgr install standalone
tlmgr install was # upgreek
tlmgr install xltxtra
tlmgr install realscripts
tlmgr install xecjk
tlmgr install mhchem
tlmgr install biber biblatex biblatex-nature
tlmgr install pgf pgfplots pgfopts
tlmgr install translator
tlmgr install silence
tlmgr install zref
tlmgr install animate media9 ocgx2 xcolor

# beamer template
tlmgr install beamertheme-metropolis
```

## latexindent

```bash
cpanm --verbose YAML::Tiny File::HomeDir Unicode::GCString Log::Log4perl Log::Dispatch::File

# curl -O https://raw.githubusercontent.com/cmhughes/latexindent.pl/master/defaultSettings.yaml
cp -f ~/Scripts/dotfiles/tex/defaultSettings.yaml \
    ~/Library/TinyTeX/texmf-dist/scripts/latexindent

```

## Fonts

```bash
brew tap homebrew/cask-fonts

brew cask install font-fira-sans
brew cask install font-fira-mono
brew cask install font-charter

# brew cask install font-noto-emoji

# brew cask install font-source-sans-pro
# brew cask install font-source-serif-pro
# brew cask install font-source-code-pro

brew cask install font-source-han-sans
brew cask install font-source-han-serif
brew cask install font-source-han-mono

# brew cask install colindean/fonts-nonfree/font-microsoft-office

# https://github.com/mozilla/Fira/archive/4.202.tar.gz
# https://noto-website-2.storage.googleapis.com/pkgs/NotoSansCJKsc-hinted.zip
# https://noto-website-2.storage.googleapis.com/pkgs/NotoSerifCJKsc-hinted.zip

fc-cache -fsv

```
