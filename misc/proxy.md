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
New-NetFirewallRule -DisplayName "WSL" -Direction Inbound -InterfaceAlias "vEthernet (WSL)" -Action Allow

```
