#!/bin/bash

BASE_DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )

cd "${BASE_DIR}" || exit

mkdir -p $HOME/.cargo

if grep -q -i RUST_PATH $HOME/.bashrc; then
    echo "==> .bashrc already contains RUST_PATH"
else
    echo "==> Updating .bashrc with RUST_PATH..."
    RUSTUP_DIST_SERVER="export RUSTUP_DIST_SERVER=https://mirrors.ustc.edu.cn/rust-static"
    RUSTUP_UPDATE_ROOT="export RUSTUP_UPDATE_ROOT=https://mirrors.ustc.edu.cn/rust-static/rustup"
    RUST_PATH="export PATH=\"\$HOME/.cargo/bin:\$PATH\""
    echo '# RUST_PATH'       >> $HOME/.bashrc
    echo $RUSTUP_DIST_SERVER >> $HOME/.bashrc
    echo $RUSTUP_UPDATE_ROOT >> $HOME/.bashrc
    echo $RUST_PATH          >> $HOME/.bashrc
    echo >> $HOME/.bashrc

    # make the above environment variables available for the rest of this script
    eval $RUSTUP_DIST_SERVER
    eval $RUSTUP_UPDATE_ROOT
    eval $RUST_PATH
fi

curl https://sh.rustup.rs -sSf | bash

# tee $HOME/.cargo/config <<EOF
# [source.crates-io]
# registry = "https://github.com/rust-lang/crates.io-index"
# replace-with = 'ustc'
# [source.ustc]
# registry = "git://mirrors.ustc.edu.cn/crates.io-index"
#
# EOF

rustup component add clippy rust-analysis rust-src rustfmt

cargo install cargo-expand
cargo install cargo-release
