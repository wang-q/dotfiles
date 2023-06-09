#!/bin/bash

BASE_DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )

cd "${BASE_DIR}" || exit

# font_install() doesn't provide the repo argument
cat <<EOF > .Rprofile
# set R mirror
# Bioconductor mirror
options(BioC_mirror="https://mirrors.ustc.edu.cn/bioc")
# CRAN mirror
options("repos" = c(CRAN="https://mirrors.ustc.edu.cn/CRAN/"))
EOF

Rscript packages.R

rm .Rprofile
