#!/bin/bash

BASE_DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )

cd "${BASE_DIR}" || exit

# pip
PYPI_MIRROR=https://mirrors.nju.edu.cn/pypi/web/simple

#pip3 install -i ${PYPI_MIRROR} --upgrade pip setuptools

pip3 install -i ${PYPI_MIRROR} pysocks cryptography
pip3 install -i ${PYPI_MIRROR} virtualenv
pip3 install -i ${PYPI_MIRROR} more-itertools zipp setuptools-scm
pip3 install -i ${PYPI_MIRROR} numpy matplotlib
pip3 install -i ${PYPI_MIRROR} pandas scipy jupyter sympy
pip3 install -i ${PYPI_MIRROR} lxml statsmodels patsy h5py
pip3 install -i ${PYPI_MIRROR} beautifulsoup4 scikit-learn seaborn

#HDF5_DIR=$(brew --prefix hdf5) pip install h5py tables

pip3 install -i ${PYPI_MIRROR} h5py tabulate # TBB

# PPanGGOLiN
pip3 install -i ${PYPI_MIRROR} tqdm tables networkx dataclasses
pip3 install -i ${PYPI_MIRROR} plotly gmpy2 colorlover bokeh

# antismash
pip3 install -i ${PYPI_MIRROR} helperlibs jinja2 joblib jsonschema markupsafe pysvg pyscss
pip3 install -i ${PYPI_MIRROR} biopython bcbio-gff

pip3 install -i ${PYPI_MIRROR} Circle-Map cutadapt importlib-metadata

pip3 install -i ${PYPI_MIRROR} deeptools


# poetry can search packages
# curl -sSL https://install.python-poetry.org | python3 -
