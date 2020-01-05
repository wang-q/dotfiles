#!/bin/bash

BASE_DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )

hash Rscript 2>/dev/null || {
    brew install r
}

cd "${BASE_DIR}" || exit

Rscript packages.R

# font_install() doesn't provide the repo argument
cat <<EOF > .Rprofile
# set R mirror
local({
    # Bioconductor mirror
    options("BioC_mirror"="https://ipv4.mirrors.ustc.edu.cn/bioc")
    # CRAN mirror
    r <- getOption("repos")
    r["CRAN"] <- "https://mirrors.nju.edu.cn/CRAN"
    options(repos=r)
})
EOF

Rscript extrafont.R

rm .Rprofile
