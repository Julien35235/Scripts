#Activer la virtualisation imbriquée sur une VM
Get-VM
Set-VMProcessor -VMName "W10" -ExposeVirtualizationExtensions $true
New-VMSwitch -Name NAT -SwitchType Internal
New-NetNat –Name LocalNAT –InternalIPInterfaceAddressPrefix "192.168.235.0/24"
#Ensuite, on va attacher une adresse IP à l'adaptateur virtuel qui est associé à notre vSwitch "NAT" :
Get-NetAdapter "vEthernet (NAT)" | New-NetIPAddress -IPAddress 192.168.235.2 -AddressFamily IPv4 -PrefixLength 24
Get-NetAdapter "Ethernet" | New-NetIPAddress -IPAddress 192.168.235.2 -DefaultGateway 192.168.235.1 -AddressFamily IPv4 -PrefixLength 24
Get-NetAdapter
Set-DnsClientServerAddress -InterfaceIndex 1 -ServerAddresses ("8.8.8.8","1.1.1.1")