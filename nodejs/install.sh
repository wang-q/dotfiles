#!/bin/bash

BASE_DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )

hash node 2>/dev/null || {
    brew install node
}

cd "${BASE_DIR}" || exit

npm install -g markdown-toc
npm install -g tldr
