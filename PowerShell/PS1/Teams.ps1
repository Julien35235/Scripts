#Générer un rapport des équipes Teams
# Installation des modules de Exchange Online Management et de MicrosoftTeams
Install-Module -Name ExchangeOnlineManagement
Install-Module -Name MicrosoftTeams
# Ensuite initier une connexion sur ces deux services à l'aide d'un compte Administrateur du tenant Office 365
#Connect-ExchangeOnline
Connect-ExchangeOnline -UseWebLogin
Connect-MicrosoftTeams
$TeamList = Get-Team | Select-Object DisplayName,GroupID
# Date de création de l'équipe
$TeamCreationDate = Get-UnifiedGroup -Identity $TeamGUID | Select -ExpandProperty WhenCreated
$TeamListReport | Export-Csv "C:\Users\TSSR-Julien\OneDrive - EPNAK - ESRP RENNES\EPNAK\TSSR\Cours\Informatiques\Reseaux\Scripts\PowerShell\PS1\CSV" -Delimiter ";" -Encoding UTF8 -NoTypeInformation