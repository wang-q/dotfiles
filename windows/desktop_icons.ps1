#----------------------------------------------------------#
# This PC in desktop
#----------------------------------------------------------#

# https://gallery.technet.microsoft.com/scriptcenter/How-to-show-This-PC-or-7cbcfe7b

# Registry key path
$path = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons\NewStartPanel"

# Property name
$name = "{20D04FE0-3AEA-1069-A2D8-08002B30309D}"

# check if the property exists
$item = Get-ItemProperty -Path $path -Name $name -ErrorAction SilentlyContinue
if ($item)  {
    #set property value
    Set-ItemProperty  -Path $path -name $name -Value 0
}
Else {
    #create a new property
    New-ItemProperty -Path $path -Name $name -Value 0 -PropertyType DWORD  | Out-Null
}
