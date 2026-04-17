# Installation des rôles RDS en PowerShell
Add-WindowsFeature RDS-RD-Server -Restart
Import-Module RemoteDesktop
Get-Command -Module RemoteDesktop
# Configurer les licensing RDS
New-RDSessionDeployment -ConnectionBroker SRV-RDS-01.tssrlab.local -SessionHost SRV-RDS-01.tssrlab.local -WebAccessServer SRV-RDS-01.tssrlab.local
Add-RDServer -Server SRV-RDS-01.tssrlab.local-Role RDS-LICENSING -ConnectionBroker SRV-RDS-01.tssrlab.local

