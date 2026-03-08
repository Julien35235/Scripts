#Installation de l'active dirctory sur des posts clients 
Install-WindowsFeature -Name "RSAT-AD-PowerShell" -IncludeAllSubFeature
Install-Module -Name WindowsCompatibility
Add-WindowsCapability -online -Name Rsat.ActiveDirectory.DS-LDS.Tools~~~~0.0.1.0
Import-Module -Name ActiveDirectory
