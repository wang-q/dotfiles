#!/bin/bash

export HOMEBREW_NO_AUTO_UPDATE=1
# export ALL_PROXY=socks5h://localhost:1080

# Clear caches
rm -f $(brew --cache)/*.incomplete

# Some building tools
echo "==> Building tools"
brew install autoconf libtool automake
brew install bison flex

# downloading tools
brew install aria2 wget

# gnu
brew install gnu-sed gnu-tar

# other tools
brew install screen htop

# large packages
if [[ "$OSTYPE" == "darwin"* ]]; then
    brew install gpg2
fi

hash gnuplot 2>/dev/null || {
    brew install gnuplot
}

hash convert 2>/dev/null || {
    brew install imagemagick
}

hash udunits2 2>/dev/null || {
    brew install udunits
}
