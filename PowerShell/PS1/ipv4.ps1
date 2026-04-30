#Configuration d’une nouvelle adresse IP
New-NetIPAddress –InterfaceIndex 12 –IPAddress 10.135.95.2 –PrefixLength 24 –DefaultGateway 10.235.95.1
Set-NetIPInterface -InterfaceIndex 12 -Dhcp {Enabled/Disabled}
# Ajout des DNS
Set-DnsClientServerAddress -InterfaceIndex 12 -ServerAddresses 8.8.8.8
Set-DnsClientServerAddress -InterfaceIndex 12 -ServerAddresses 10.235.95.1
Get-NetIPConfiguration