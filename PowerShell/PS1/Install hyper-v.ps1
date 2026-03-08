#Installation de l'hyperviseur de Hyper-V en PowerShell
Enable-WindowsOptionalFeature -Online -FeatureName Microsoft-Hyper-V-Management-PowerShell
Enable-WindowsOptionalFeature -Online -FeatureName Microsoft-Hyper-V-Tools-All
Enable-WindowsOptionalFeature -Online -FeatureName Microsoft-Hyper-V-All
# Install only the PowerShell module
Install-WindowsFeature -Name Hyper-V-PowerShell
# Install Hyper-V Manager and the PowerShell module (HVM only available on GUI systems)
Install-WindowsFeature -Name RSAT-Hyper-V-Tools
