#Renommer sa machine 
Rename-Computer -NewName ADDS01-TSSR -Force
#Redemarrage de sa machine 
Restart-Computer
#Addreasage IPV4
New-NetIPAddress -IPAddress "10.235.95.2" -PrefixLength "24" -InterfaceIndex (Get-NetAdapter).ifIndex -DefaultGateway "10.235.95.1"
Set-DnsClientServerAddress -InterfaceIndex (Get-NetAdapter).ifIndex -ServerAddresses ("127.0.0.1")
Rename-NetAdapter -Name Ethernet0 -NewName LAN

#Creation d'un serveur ADS
$DomainNameDNS = "ads.tssr.local"
$DomainNameNetbios = "TSSR"

$ForestConfiguration = @{
'-DatabasePath'= 'C:\Windows\NTDS';
'-DomainMode' = 'Default';
'-DomainName' = $DomainNameDNS;
'-DomainNetbiosName' = $DomainNameNetbios;
'-ForestMode' = 'Default';
'-InstallDns' = $true;
'-LogPath' = 'C:\Windows\NTDS';
'-NoRebootOnCompletion' = $false;
'-SysvolPath' = 'C:\Windows\SYSVOL';
'-Force' = $true;
'-CreateDnsDelegation' = $false }
Import-Module ADDSDeployment
Install-ADDSForest @ForestConfiguration
