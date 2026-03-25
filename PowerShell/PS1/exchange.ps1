# Installer les prérequis Exchange
Install-WindowsFeature Server-Media-Foundation, NET-Framework-45-Core, NET-Framework-45-ASPNET, `
NET-WCF-HTTP-Activation45, NET-WCF-TCP-Activation45, RPC-over-HTTP-proxy,`
Web-Asp-Net45, Web-ISAPI-Ext, Web-ISAPI-Filter, Web-Metabase, Web-Lgcy-Mgmt-Console
Install-WindowsFeature Server-Media-Foundation, NET-Framework-45-Features, RPC-over-HTTP-proxy, RSAT-Clustering, RSAT-Clustering-CmdInterface, RSAT-Clustering-Mgmt, RSAT-Clustering-PowerShell, WAS-Process-Model, Web-Asp-Net45, Web-Basic-Auth, Web-Client-Auth, Web-Digest-Auth, Web-Dir-Browsing, Web-Dyn-Compression, Web-Http-Errors, Web-Http-Logging, Web-Http-Redirect, Web-Http-Tracing, Web-ISAPI-Ext, Web-ISAPI-Filter, Web-Lgcy-Mgmt-Console, Web-Metabase, Web-Mgmt-Console, Web-Mgmt-Service, Web-Net-Ext45, Web-Request-Monitor, Web-Server, Web-Stat-Compression, Web-Static-Content, Web-Windows-Auth, Web-WMI, Windows-Identity-Foundation, RSAT-ADDS
# URL du MSI (x86 dans ton exemple)
$url = "https://download.microsoft.com/download/D/8/1/D81E5DD6-1ABB-46B0-9B4B-21894E18B77F/rewrite_x86_en-US.msi"

# Chemin local
$dest = "C:\Temp\rewrite_x86.msi"

# Téléchargement binaire correct
iwr $url -OutFile $dest

# Installation silencieuse
Start-Process msiexec.exe -ArgumentList "/i `"$dest`" /quiet /norestart" -Wait
# URL du .NET Framework 4.8 installer
$url = "https://download.visualstudio.microsoft.com/download/pr/014120d7-d689-4305-befd-3cb711108212/0fd66638cde16859462a6243a4629a50/ndp48-x86-x64-allos-enu.exe"

# Chemin de destination
$dest = "C:\Temp\ndp48.exe"

# Téléchargement binaire
Invoke-WebRequest -Uri $url -OutFile $dest