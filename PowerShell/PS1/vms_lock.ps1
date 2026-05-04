#Verrouiller la console de la VM à la fermeture 
Set-VM "ADDS-035" -LockOnDisconnect On
Get-VM | Set-VM -LockOnDisconnect On