#!/bin/bash

BASE_DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )

hash Rscript 2>/dev/null || {
    brew install r
}

cd ${BASE_DIR}

Rscript packages.R

Rscript extrafont.R
