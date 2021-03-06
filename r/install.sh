#!/bin/bash

BASE_DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )

hash Rscript 2>/dev/null || {
    brew install r
}

hash udunits2 2>/dev/null || {
    brew install udunits
}

hash gdal-config 2>/dev/null || {
    brew install gdal
}

cd "${BASE_DIR}" || exit

# font_install() doesn't provide the repo argument
cat <<EOF > .Rprofile
# set R mirror
# Bioconductor mirror
options(BioC_mirror="https://mirrors4.tuna.tsinghua.edu.cn/bioconductor")
# CRAN mirror
options("repos" = c(CRAN="https://mirrors4.tuna.tsinghua.edu.cn/CRAN/"))
EOF

Rscript packages.R

Rscript extrafont.R

rm .Rprofile
