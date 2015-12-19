#!/bin/bash

MPVDIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )

# symlink
echo "mpv configuring"
mkdir -p ~/.config
cd ~/.config
ln -Fs "$MPVDIR"

# as default player
APPFILE=~/Applications/mpv.app

if [ ! -e "$APPFILE" ]; then
    exit
fi

BUNDLEID=$(mdls -name kMDItemCFBundleIdentifier -r $APPFILE)
echo "mpv id: $BUNDLEID"

EXTS=( 3GP ASF AVI FLV M4V MKV MOV MP4 MPEG MPG MPG2 MPG4 RMVB WMV )

for ext in ${EXTS[@]}
do
	lower=$(echo $ext | awk '{print tolower($0)}')
	duti -s $BUNDLEID $ext all
	duti -s $BUNDLEID $lower all
done
