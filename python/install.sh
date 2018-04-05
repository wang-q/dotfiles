#!/bin/bash

BASE_DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )

hash perl 2>/dev/null || {
    brew install perl
}

cd ${BASE_DIR}

pip install numpy matplotlib
pip install pandas sympy
pip install ipython ipynb
