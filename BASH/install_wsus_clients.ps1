#Installation de WSUS dans des postes clients
Add-WindowsCapability -Online -Name Rsat.WSUS.Tools~~~~0.0.1.0
Install-WindowsFeature -Name UpdateServices-Ui
Import-Module WebAdministration
Set-ItemProperty -Path IIS:\AppPools\WsusPool -Name queueLength -Value 2500
Set-ItemProperty -Path IIS:\AppPools\WsusPool -Name cpu.resetInterval -Value "00.00:15:00"
Set-ItemProperty -Path IIS:\AppPools\WsusPool -Name recycling.periodicRestart.privateMemory -Value 0
Set-ItemProperty -Path IIS:\AppPools\WsusPool -Name failure.loadBalancerCapabilities -Value "TcpLevel"