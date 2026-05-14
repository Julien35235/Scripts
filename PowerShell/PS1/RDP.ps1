#Activation du bureau à distance RDP 
Set-ItemProperty -Path "HKLM:\System\CurrentControlSet\Control\Terminal Server" -Name "fDenyTSConnections" -Value 0
Enable-NetFirewallRule -DisplayGroup "Bureau à distance"
Get-NetFirewallRule -DisplayGroup "Bureau à distance"
#Redemarage du service RDP
Restart-Service TermService -Force