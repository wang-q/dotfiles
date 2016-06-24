#!/bin/bash

RDIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )

cd ${RDIR}

Rscript install.R
