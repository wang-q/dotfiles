# Command line proxies for each platform

## Powershell

```powershell
$ENV:ALL_PROXY='socks5h://localhost:10808'
$ENV:HTTP_PROXY='http://localhost:10809'
$ENV:HTTPS_PROXY='http://localhost:10809'

```

## WSL using Host v2ray

```shell
WINDOWS_HOST=$(ip --json route show default | jq -re '.[].gateway')

export ALL_PROXY="socks5h://${WINDOWS_HOST}:10808"

export HTTP_PROXY="http://${WINDOWS_HOST}:10809"
export HTTPS_PROXY="http://${WINDOWS_HOST}:10809"
export RSYNC_PROXY="${WINDOWS_HOST}:10809"

# sed -Ei "s/^socks5.+$/socks5 ${WINDOWS_HOST} 10808/" ~/.proxychains/proxychains.conf

```

The following may be needed

```powershell
netsh interface ipv4 show interface

New-NetFirewallRule -DisplayName "WSL" -Direction Inbound -InterfaceAlias "vEthernet (WSL)" -Action Allow

New-NetFirewallRule -DisplayName "WSL" -Direction Inbound -InterfaceAlias "vEthernet (WSL (Hyper-V firewall))" -Action Allow

```

## macOS with Clash

```shell
export HTTPS_PROXY=http://127.0.0.1:7890 HTTP_PROXY=http://127.0.0.1:7890 ALL_PROXY=socks5://127.0.0.1:7890 RSYNC_PROXY=127.0.0.1:10809

```
