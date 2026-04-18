# Scoop

## Install Scoop

```powershell
Set-ExecutionPolicy RemoteSigned -Scope CurrentUser

# $ENV:ALL_PROXY='socks5h://localhost:10808'
# $ENV:HTTP_PROXY='http://localhost:10809'
# $ENV:HTTPS_PROXY='http://localhost:10809'

irm get.scoop.sh | iex

scoop bucket add main
scoop bucket add extras
scoop bucket add versions

scoop install 7zip
scoop install dark innounp

```

## Install packages

```powershell
# downloading tools
scoop install aria2 wget

scoop config aria2-enabled false

# gnu
scoop install gzip unzip grep
scoop install sed

scoop install pup

# extra
scoop install sqlitestudio

# scoop install proxychains

# List installed packages
scoop list

```
