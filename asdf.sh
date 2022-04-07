#!/bin/bash

BASE_DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )

# asdf
echo "==> Installing asdf"

brew install $( brew deps asdf )

git clone https://github.com/asdf-vm/asdf.git ~/.asdf --branch v0.9.0

if grep -q -i ASDF_PATH $HOME/.bashrc; then
    echo "==> .bashrc already contains ASDF_PATH"
else
    echo "==> Updating .bashrc with ASDF_PATH..."
    ASDF_PATH=". $HOME/.asdf/asdf.sh"
    echo '# ASDF_PATH' >> $HOME/.bashrc
    echo $ASDF_PATH    >> $HOME/.bashrc
    echo >> $HOME/.bashrc

    # make the above environment variables available for the rest of this script
    eval $ASDF_PATH
fi

echo "==> Use grep to locate asdf plugins"
asdf plugin list all | grep -i "^node"
asdf plugin list all | grep -i "^r "
asdf plugin list all | grep -i "^perl"

# nodejs
echo "==> Installing nodejs"
brew install gpg gawk

asdf plugin add nodejs https://github.com/asdf-vm/asdf-nodejs.git

# asdf list all nodejs

asdf install nodejs lts-gallium

asdf global nodejs lts-gallium

echo "Node version"
node --version

npm install -g markdown-toc
npm install -g prettier
npm install -g tldr

# Perl 
# brew install berkeley-db gdbm openssl@1.1

# asdf plugin add perl https://github.com/ouest/asdf-perl

# asdf install perl 5.34.1


# R
# echo "==> Installing R"
# brew install gcc xz libxt cairo

# asdf plugin add R https://github.com/asdf-community/asdf-r.git

# # asdf list all R 
# # https://cloud.r-project.org/src/base/R-4/

# asdf install R 4.1.3

# asdf global R 4.1.3

# # versions
# echo "==> All tool verions"
# cat ~/.tool-versions
