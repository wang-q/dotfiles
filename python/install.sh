#!/bin/bash

BASE_DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )

hash python 2>/dev/null || {
    brew install python
}

cd ${BASE_DIR}

pip3 install --upgrade pip setuptools

pip3 install numpy matplotlib
pip3 install pandas sympy
pip3 install jupyter scipy
pip3 install lxml statsmodels patsy
pip3 install beautifulsoup4 scikit-learn seaborn
