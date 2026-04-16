#Installation du serveur DHCP 
Install-WindowsFeature -Name DHCP -IncludeManagementTools
netsh dhcp add securitygroups
Add-DhcpServerSecurityGroup
Restart-Service dhcpserver