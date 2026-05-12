# Backup and restore programs and data

```powershell
cbp snap save "$env:APPDATA/GitHub Desktop" -o gitbubdesktop.snap.tar.gz

cbp snap save "$env:APPDATA/Scooter Software" -x "*.bak" -o beyondcompare.snap.tar.gz

```
