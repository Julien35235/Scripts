Install-Module AutomatedLab -SkipPublisherCheck -AllowClobber
Install-Module -Name Pester -Force -SkipPublisherCheck
New-LabSourcesFolder -DriveLetter V
V:\LabSources\ISOs
Get-LabAvailableOperatingSystem
# Paramètres par défaut pour les VM du lab
$PSDefaultParameterValues = @{
    'Add-LabMachineDefinition:Network' = 'Lab_tssr'
    'Add-LabMachineDefinition:Memory' = 4GB
    'Add-LabMachineDefinition:DnsServer1'= '192.168.1.100'
    'Add-LabMachineDefinition:Gateway' = '192.168.1.1'    
    'Add-LabMachineDefinition:OperatingSystem'= 'Windows Server 2025 Standard (Desktop Experience)'
    'Add-LabMachineDefinition:DomainName'= 'tssr.local'     
}
### Routeur
# Configuration de la carte réseau de la VM
$LabNet_Routeur = @()
$LabNet_Routeur += New-LabNetworkAdapterDefinition -VirtualSwitch "LabADNet" -Ipv4Address 10.10.10.1
$LabNet_Routeur += New-LabNetworkAdapterDefinition -VirtualSwitch "LabWAN" -UseDhcp

# Déclarer une nouvelle VM
Add-LabMachineDefinition -Name VM-Routeur -Roles Routing  -OperatingSystem "Windows Server 2022 Standard" `
                         -NetworkAdapter $LabNet_Routeur -Memory 2048MB

### Contrôleur de domaine SRV-ADDS-01
# Configuration de la carte réseau de la VM
$LabNet_SRV_ADDS_01 = @()
$LabNet_SRV_ADDS_01 += New-LabNetworkAdapterDefinition -VirtualSwitch "LabADNet" -Ipv4Address 192.168.10.101

# Configurer le domaine Active Directory
$ADDSConfig = Get-LabMachineRoleDefinition -Role RootDC @{
    NetBiosDomainName = 'IT-Connect'
    ForestFunctionalLevel = 'Win2025'
    DomainFunctionalLevel = 'Win2025'
    SiteName = 'tssr.local'
    SiteSubnet = '192.168.1.1/24'
}

# Déclarer une nouvelle VM
Add-LabMachineDefinition -Name VM-SRV-ADDS-01 -Roles $ADDSConfig `
                         -DomainName "tssr.local" -NetworkAdapter $LabNet_SRV_ADDS_01

Install-Lab

