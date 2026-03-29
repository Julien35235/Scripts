$adapters= Get-NetIPAddress -AddressFamily IPv4
foreach ($adapter in $adapters) {
Write-Host "Interface : $($adapter.InterfaceAlias)"
Write-Host "Adresse IP : $($adapter.IPv4Address)"
Write-Host "----------"
}