# Stop SSH service
Stop-Service ssh

# Disable SSH service startup
Set-Service -Name ssh -StartupType "Disabled"

# Remove firewall rule for SSH
Get-NetFirewallRule -DisplayName 'OpenSSH-Server-In-TCP' | Remove-NetFirewallRule

# Uninstall OpenSSH server
Add-WindowsCapability -Online -Name OpenSSH.Server~~~~0.0.1.0 -Remove