# Installation de OpenSSH sur les machines 
Add-WindowsCapability -Online -Name OpenSSH.Server~~~~0.0.1.0
# Demarrage du service SSH
Start-Service sshd
# Demarrage automatique du service SSH
Set-Service -Name sshd -StartupType "Automatic"
# Redemarrage du service SSH
 Restart-Service sshd 
 #Configuration du fw de Windows
 New-NetFirewallRule -Name 'OpenSSH-Server-In-TCP' -DisplayName 'OpenSSH Server (sshd)' -Enabled True -Direction Inbound -Protocol TCP -Action Allow -LocalPort 22
 #Permissions au utilisateurs en SSH
 AllowGroups administrators "openssh users" 
 AllowGroups administrators "Utilisateurs OpenSSH"
 Restart-Service sshd