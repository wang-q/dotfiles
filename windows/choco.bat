@powershell -NoProfile -ExecutionPolicy Bypass -Command "iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))" && SET "PATH=%PATH%;%ALLUSERSPROFILE%\chocolatey\bin"

choco install -y dotnet3.5
choco install -y vcredist2008 vcredist2010 vcredist2012 vcredist2013
choco install -y curl wget
choco install -y windirstat
