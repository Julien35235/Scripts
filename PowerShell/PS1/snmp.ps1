#Installation du serveur SNMP
Get-WindowsFeature -Name *snmp* | Install-WindowsFeature
Get-WindowsFeature -Name *snmp*
#Redemarrage du service SNMP
Restart-Service SNMP