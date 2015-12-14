#!/bin/bash

echo "Hammerspoon configuring"

HAMMERSPOONDIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )

find ${HOME} -type d -maxdepth 1 -name '.hammerspoon' | xargs rm -fr
ln -Fs "$HAMMERSPOONDIR" ${HOME}/.hammerspoon
