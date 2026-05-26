#Installation du SSH Client
Add-WindowsCapability -Online -Name OpenSSH.Client
dism /online /Add-Capability /CapabilityName:OpenSSH.Client~~~~0.0.1.0
