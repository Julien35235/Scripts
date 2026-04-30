#Installion du module Burnt Toast
Install-Module BurntToast
#Ensuite, on peut en profiter pour lister les cmdlets disponibles
Get-Command -Module BurntToast
Set-BTFunctionLevel Advanced
New-BTAppId -AppId "TSSR notification"
New-BurntToastNotification
New-BurntToastNotification -AppId "TSSR notification" -AppLogo "C:\png\logo.png" -Text "PowerShell Notification" , "This module is very cool ! :-)"