#Installation du serveur DHCP 
Install-WindowsFeature -Name DHCP -IncludeManagementTools
netsh dhcp add securitygroups
Add-DhcpServerSecurityGroup
Restart-Service dhcpserver

#Création d’une étendue DHCP
Add-DhcpServerv4Scope -Name "Clients" -StartRange 10.235.95.10 -EndRange 10.235.95.100 -SubnetMask 255.255.255.0
#On définit la passerelle par défaut  10.235.95.1, grâce à l'option DHCP
Set-DhcpServerv4OptionDefinition -OptionId 3 -DefaultValue 10.235.95.1
##On définit le DNS par défaut  10.235.95.2, grâce à l'option DHCP
Set-DhcpServerv4OptionDefinition -OptionId 6 -DefaultValue 10.235.95.2
Set-DhcpServerv4Scope -ScopeId 172.16.0 -Name "Clients" -State Active
#Afin de vérifier que la configuration est bien prise en compte, on peut lister les scopes DHCP du serveur 
Get-DhcpServerv4Scope
