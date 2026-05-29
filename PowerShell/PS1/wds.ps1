#Installation du serveur WDS
Install-WindowsFeature -Name WDS -IncludeManagementTools
Install-WindowsFeature wds-deployment -includemanagementtools