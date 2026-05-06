#Installation du serveur WEB de ILS
Install-WindowsFeature Web-Server -IncludeManagementTools
Install-WindowsFeature -name Web-Server -IncludeManagementTools
#Activation du démarrage automatique du serveur WEB
Set-Service -name W3SVC -startupType Automatic