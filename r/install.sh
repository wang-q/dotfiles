#!/bin/bash

BASE_DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )

if [ hash Rscript 2>/dev/null ];
then
    if [[ `uname` == 'Darwin' ]];
    then
        brew install homebrew/science/r
    else
        brew install homebrew/science/r --without-x11
    fi
fi

cd ${BASE_DIR}

Rscript install.R

cat <<EOF > .Rprofile
# set R mirror
local({r <- getOption("repos")
   r["CRAN"] <- "https://mirrors.tuna.tsinghua.edu.cn/CRAN"
   options(repos=r)
})

EOF

Rscript extrafont.R

rm .Rprofile
