# Install TexLive by TinyTex

## [TinyTex](https://yihui.org/tinytex/)

```bash
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

```bash
brew install pandoc imagemagick gifsicle

sudo apt install pandoc imagemagick gifsicle

```

```powershell
scoop install pandoc imagemagick gifsicle

scoop cache rm *; scoop uninstall pandoc; scoop install pandoc

```

## `tlmgr`

```bash
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

```bash
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

```bash
cbp install -t font arial
cbp install -t font charter
cbp install -t font helvetica

cbp install -t font fira
cbp install -t font jetbrains-mono
cbp install -t font source-han-sans
cbp install -t font source-han-serif
cbp install -t font lxgw-wenkai

```
