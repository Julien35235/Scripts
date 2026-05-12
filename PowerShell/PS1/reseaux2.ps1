# Lister les cartes réseau
Get-NetAdapter | fl Name, InterfaceIndex
Get-NetAdapter | fl Name, InterfaceIndex, MacAddress, MediaConnectionState, LinkSpeed
#Renomage de la carte réseau
Get-NetAdapter -Name Ethernet0 | Rename-NetAdapter -NewName LAN
#Deactivation de la carte réseau
Disable-NetAdapter -Name LAN
#Status de la carte réseau 
(Get-NetAdapter -Name LAN).Status
#Activation de la carte réseau 
Enable-NetAdapter -Name LAN
#Redemmarage de la carte réseau
Restart-NetAdapter -Name LAN