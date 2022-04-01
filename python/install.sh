#!/bin/bash

BASE_DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )

cd "${BASE_DIR}" || exit

# pip
PYPI_MIRROR=https://pypi.tuna.tsinghua.edu.cn/simple

#pip3 install -i ${PYPI_MIRROR} --upgrade pip setuptools

pip3 install -i ${PYPI_MIRROR} pysocks
pip3 install -i ${PYPI_MIRROR} numpy matplotlib
pip3 install -i ${PYPI_MIRROR} pandas sympy
pip3 install -i ${PYPI_MIRROR} jupyter scipy
pip3 install -i ${PYPI_MIRROR} lxml statsmodels patsy
pip3 install -i ${PYPI_MIRROR} beautifulsoup4 scikit-learn seaborn

# poetry can search packages
curl -sSL https://install.python-poetry.org | python3 -
