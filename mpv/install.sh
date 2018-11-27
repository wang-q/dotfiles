#!/bin/bash

BASE_DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )

# symlink
echo "mpv configuring"
mkdir -p ~/.config
cd ~/.config
ln -Fs "${BASE_DIR}"

# as default player
APP_FILE=/Applications/mpv.app

if [ ! -e "${APP_FILE}" ]; then
    echo "mpv.app doesn't exist"
    exit;
fi

BUNDLE_ID=$(mdls -name kMDItemCFBundleIdentifier -r $APP_FILE)
echo "mpv id: ${BUNDLE_ID}"

EXTS=( 3GP ASF AVI FLV M4A M4V MKV MOV MP4 MPEG MPG MPG2 MPG4 RMVB WMV )

for ext in ${EXTS[@]}
do
	lower=$(echo $ext | awk '{print tolower($0)}')
	duti -s $BUNDLEID $ext all
	duti -s $BUNDLEID $lower all
done
