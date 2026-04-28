# Rust and C/C++

## [C++ Build Tools](https://visualstudio.microsoft.com/visual-cpp-build-tools/)

Select `Desktop development with C++` and Language packs English/Chinese

[IDE](https://visualstudio.microsoft.com/free-developer-offers/)

## docs from Microsoft

https://docs.microsoft.com/en-us/windows/dev-environment/rust/setup

## [`rustup`](https://rustup.rs/)

```powershell
# rustup
rustup self update
rustup update
rustup component add clippy rust-analysis rust-src rustfmt

cargo install cargo-expand
cargo install cargo-release
```

* vscode extensions

```powershell
# code --install-extension rust-lang.rust
# code --install-extension matklad.rust-analyzer

```

> Due to it's design IO between the host (Windows) and virtual machine (distro inside WSL2) is slow and the latency is enormous.
> With WSL2 you should be always compiling your project from Linux filesystem and not from Windows mounted directories

https://github.com/rust-lang/rust/issues/55684#issuecomment-734433698
