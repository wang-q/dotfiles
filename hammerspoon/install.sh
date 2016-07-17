#!/bin/bash

echo "Hammerspoon configuring"

BASE_DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )

find ${HOME} -type d -maxdepth 1 -name '.hammerspoon' | xargs rm -fr
ln -Fs "${BASE_DIR}" ${HOME}/.hammerspoon
