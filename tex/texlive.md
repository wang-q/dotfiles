# Install TexLive by TinyTex

## [TinyTex](https://yihui.org/tinytex/)

```shell
curl -sL "https://yihui.org/tinytex/install-bin-unix.sh" | sh

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

```shell
brew install pandoc imagemagick gifsicle

sudo apt install pandoc imagemagick gifsicle

```

```powershell
scoop install pandoc imagemagick gifsicle

scoop cache rm *; scoop uninstall pandoc; scoop install pandoc

```

## `tlmgr`

```shell
tlmgr option repository https://mirrors.ustc.edu.cn/CTAN/systems/texlive/tlnet/

tlmgr update --self --all
tlmgr path add
fmtutil-sys --all

# tlmgr search --global --file "/times.sty"

tlmgr install $(curl -L https://yihui.org/gh/tinytex/tools/pkgs-custom.txt | tr '\n' ' ')
tlmgr install $(curl -L https://yihui.org/gh/tinytex/tools/pkgs-yihui.txt | tr '\n' ' ')

tlmgr install latexmk pdfjam pdfcrop arara latexindent
tlmgr install pdflscape epstopdf-pkg # pdfjam
tlmgr install standalone
tlmgr install was # upgreek
tlmgr install fontawesome5
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
tlmgr install makecell grffile caption

# beamer template
tlmgr install beamertheme-metropolis

# forest
tlmgr install forest inlinedef ctex

tlmgr path add

```

## latexindent

```shell
cpanm --verbose YAML::Tiny File::HomeDir Unicode::GCString Log::Log4perl Log::Dispatch::File

# curl -O https://raw.githubusercontent.com/cmhughes/latexindent.pl/master/defaultSettings.yaml

# macOS
cp -f ~/Scripts/dotfiles/tex/defaultSettings.yaml \
    ~/Library/TinyTeX/texmf-dist/scripts/latexindent

# Linux
cp -f ~/Scripts/dotfiles/tex/defaultSettings.yaml \
    ~/.TinyTeX/texmf-dist/scripts/latexindent

```

## Fonts

```shell
if [[ $(uname) == 'Darwin' ]]; then
    FONT_DIR="$HOME/Library/Fonts"
else
    FONT_DIR="$HOME/.fonts"
fi
mkdir -p ${FONT_DIR}
echo ${FONT_DIR}

brew install cabextract

# Arial
curl -LO 'https://downloads.sourceforge.net/corefonts/arial32.exe'

cabextract --list arial32.exe
cabextract --filter='*.TTF' arial32.exe --directory ${FONT_DIR}

rm -f arial32.exe

# Fira Sans and Mono
curl -L 'https://github.com/mozilla/Fira/archive/4.202.tar.gz' > Fira.tar.gz

if [[ $(uname) == 'Darwin' ]]; then
    gtar -xvzf Fira.tar.gz --wildcards "Fira-4.202/ttf/*.ttf"
else
    tar -xvzf Fira.tar.gz --wildcards "Fira-4.202/ttf/*.ttf"
fi

mv Fira-4.202/ttf/* ${FONT_DIR}

rm -fr Fira-4.202
rm Fira.tar.gz

# JetBrains Mono
curl -L 'https://github.com/JetBrains/JetBrainsMono/releases/download/v2.304/JetBrainsMono-2.304.zip' > JetBrainsMono.zip

unzip -j JetBrainsMono.zip -d ${FONT_DIR} '*.ttf'

rm JetBrainsMono.zip

# Charter
curl -L 'https://practicaltypography.com/fonts/Charter%20210112.zip' > Charter.zip

unzip -j Charter.zip -d ${FONT_DIR} '*.ttf'

rm Charter.zip

# Source Han Sans 思源黑体
curl -LO https://github.com/adobe-fonts/source-han-sans/releases/download/2.004R/SourceHanSansSC.zip

unzip -j SourceHanSansSC.zip -d ${FONT_DIR} '*.otf'

rm SourceHanSansSC.zip

# Source Han Serif 思源宋体
curl -LO https://github.com/adobe-fonts/source-han-serif/releases/download/2.001R/09_SourceHanSerifSC.zip

unzip -j 09_SourceHanSerifSC.zip -d ${FONT_DIR} '*.otf'

rm 09_SourceHanSerifSC.zip

# LXGW WenKai GB 霞鹜文楷 GB
curl -LO https://github.com/lxgw/LxgwWenKai/releases/download/v1.330/lxgw-wenkai-v1.330.zip

unzip -j lxgw-wenkai-v1.330.zip -d ${FONT_DIR} '*.ttf'

rm lxgw-wenkai-*.zip

fc-cache -fv ${FONT_DIR}

```
