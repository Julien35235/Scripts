#Renommage de la machine
Rename-Computer -NewName SRV-ADDS01-TSSR -Force
#Redemarrage de la machine
Restart-Computer
#Configuration réseau
New-NetIPAddress -IPAddress "10.235.135.2" -PrefixLength "24" -InterfaceIndex (Get-NetAdapter).ifIndex -DefaultGateway "10.235.135.1"
Set-DnsClientServerAddress -InterfaceIndex (Get-NetAdapter).ifIndex -ServerAddresses ("127.0.0.1")
#Renommage de la carte réseau
Rename-NetAdapter -Name Ethernet0 -NewName LAN
#Installation des rôles pour le serveur ADS
$FeatureList = @("RSAT-AD-Tools","AD-Domain-Services","DNS")

Foreach($Feature in $FeatureList){

   if(((Get-WindowsFeature-Name $Feature).InstallState)-eq"Available"){

     Write-Output"Feature $Feature will be installed now !"

     Try{

        Add-WindowsFeature-Name $Feature -IncludeManagementTools -IncludeAllSubFeature

        Write-Output"$Feature : Installation is a success !"

     }Catch{

        Write-Output"$Feature : Error during installation !"
     }
   } # if(((Get-WindowsFeature -Name $Feature).InstallState) -eq "Available")
} # Foreach($Feature in $FeatureList)

#Création du domaine Active Directory
$DomainNameDNS = "tssrlab.local"
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

