#!/bin/bash

echo "Hammerspoon configuring"

BASE_DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )

echo "BASE_DIR ${BASE_DIR}"

find ${HOME} -type d -maxdepth 1 -name '.hammerspoon' | xargs rm -fr
cd $HOME
ln -fs "${BASE_DIR}" ~/.hammerspoon
