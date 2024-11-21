# Command line proxies for each platform

## Powershell

```powershell
$ENV:ALL_PROXY='socks5h://localhost:7890'; $ENV:HTTP_PROXY='http://localhost:7890'; $ENV:HTTPS_PROXY='http://localhost:7890'

```

## WSL using Host v2ray

```shell
WINDOWS_HOST=$(ip --json route show default | jq -re '.[].gateway')

export ALL_PROXY="socks5h://${WINDOWS_HOST}:7890" HTTP_PROXY="http://${WINDOWS_HOST}:7890" HTTPS_PROXY="http://${WINDOWS_HOST}:7890" RSYNC_PROXY="${WINDOWS_HOST}:7890"

# sed -Ei "s/^socks5.+$/socks5 ${WINDOWS_HOST} 7890/" ~/.proxychains/proxychains.conf

```

The following may be needed

```powershell
netsh interface ipv4 show interface

New-NetFirewallRule -DisplayName "WSL" -Direction Inbound -InterfaceAlias "vEthernet (WSL)" -Action Allow

New-NetFirewallRule -DisplayName "WSL" -Direction Inbound -InterfaceAlias "vEthernet (WSL (Hyper-V firewall))" -Action Allow

```

## macOS/Linux with Clash

```shell
export ALL_PROXY=socks5://127.0.0.1:7890 HTTPS_PROXY=http://127.0.0.1:7890 HTTP_PROXY=http://127.0.0.1:7890 RSYNC_PROXY=127.0.0.1:7890

```
