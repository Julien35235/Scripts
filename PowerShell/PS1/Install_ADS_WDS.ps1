#Installatalion de l'ADS dans WDS en PowerShell 
Install-WindowsFeature -Name AD-Domain-Services -IncludeManagementTools
Install-ADDSForest -DomainName "ads.tssr.local" -InstallDNS
Import-Module ADDSDeployment