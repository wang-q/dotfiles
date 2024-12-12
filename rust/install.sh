#!/bin/bash

BASE_DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )

cd "${BASE_DIR}" || exit

mkdir -p $HOME/.cargo

if grep -q -i RUST_PATH $HOME/.bashrc; then
    echo "==> .bashrc already contains RUST_PATH"
else
    echo "==> Updating .bashrc with RUST_PATH..."
    RUST_PATH="export PATH=\"\$HOME/.cargo/bin:\$PATH\""
    echo '# RUST_PATH'       >> $HOME/.bashrc
    echo $RUST_PATH          >> $HOME/.bashrc
    echo >> $HOME/.bashrc

    # make the above environment variables available for the rest of this script
    eval $RUST_PATH
fi

echo "==> Install rustup"
curl https://sh.rustup.rs -sSf | bash -s -- -y

rustup component add clippy rust-analysis rust-src rustfmt

# This cargo mirror can't release crates
#tee $HOME/.cargo/config <<EOF
#[source.crates-io]
#registry = "https://github.com/rust-lang/crates.io-index"
#replace-with = 'ustc'
#[source.ustc]
#registry = "git://ipv4.mirrors.ustc.edu.cn/crates.io-index"
#
#EOF

cargo install cargo-expand
cargo install cargo-release
