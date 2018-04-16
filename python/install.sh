#!/bin/bash

BASE_DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )

hash python 2>/dev/null || {
    brew install python
}

cd ${BASE_DIR}

pip install --upgrade pip setuptools

pip install numpy matplotlib
pip install pandas sympy
pip install jupyter
pip install scipy
