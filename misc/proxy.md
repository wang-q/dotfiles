# Command Line Proxy Settings for Different Platforms

This file provides proxy configuration examples for:
- Windows (Powershell)
- WSL using Host Clash
- macOS/Linux with Clash

## Windows (Powershell)

```powershell
# Set proxy for all protocols (socks5h), HTTP and HTTPS
$ENV:ALL_PROXY='socks5h://localhost:7890'; $ENV:HTTP_PROXY='http://localhost:7890'; $ENV:HTTPS_PROXY='http://localhost:7890'

```

## WSL using Host Clash

```bash
# Get Windows host IP address
WINDOWS_HOST=$(ip --json route show default | jq -re '.[].gateway')

# Set proxy environment variables
export ALL_PROXY="socks5h://${WINDOWS_HOST}:7890" HTTP_PROXY="http://${WINDOWS_HOST}:7890" HTTPS_PROXY="http://${WINDOWS_HOST}:7890" RSYNC_PROXY="${WINDOWS_HOST}:7890"

```

The following may be needed

```powershell
netsh interface ipv4 show interface

New-NetFirewallRule -DisplayName "WSL" -Direction Inbound -InterfaceAlias "vEthernet (WSL)" -Action Allow
New-NetFirewallRule -DisplayName "WSL" -Direction Inbound -InterfaceAlias "vEthernet (Default Switch)" -Action Allow
New-NetFirewallRule -DisplayName "WSL" -Direction Inbound -InterfaceAlias "vEthernet (WSL (Hyper-V firewall))" -Action Allow

```

## macOS/Linux with Clash

```bash
# Set proxy environment variables for Clash
export ALL_PROXY=socks5://127.0.0.1:7890 \
       HTTPS_PROXY=http://127.0.0.1:7890 \
       https_proxy=http://127.0.0.1:7890 \
       HTTP_PROXY=http://127.0.0.1:7890 \
       http_proxy=http://127.0.0.1:7890 \
       RSYNC_PROXY=127.0.0.1:7890

# Test proxy connection
curl -I https://www.google.com

# Unset proxy
unset ALL_PROXY HTTPS_PROXY https_proxy HTTP_PROXY http_proxy RSYNC_PROXY

```
