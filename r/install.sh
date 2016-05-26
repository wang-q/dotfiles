#!/bin/bash

RDIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )

cd ${RDIR}

cat <<EOF > .Rprofile
# set R mirror
local({r <- getOption("repos")
   r["CRAN"] <- "https://mirrors.tuna.tsinghua.edu.cn/CRAN"
   options(repos=r)
})

EOF

Rscript install.R

rm .Rprofile
