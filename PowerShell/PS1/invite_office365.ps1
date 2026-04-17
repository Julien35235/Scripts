# Installation du module de AzureAD
Install-Module -Name AzureAD
#Ensuite, il faut créer un objet avec les credentials et nous allons l'utiliser avec le cmdlet "Connect-AzureAD" afin d'initier une connexion 
# avec le tenant.
$Credentials = Get-Credential 
$Credentials.password.MakeReadOnly()
# Connexion à Azure
Connect-AzureAD -Credential $Credentials
# Creation d'un compte invité dans Office 365 
New-AzureADMSInvitation -InvitedUserEmailAddress "usertssr@tssrlab.local" -SendInvitationMessage $true -InviteRedirectUrl "https://teams.microsoft.com/"
#Lorsque le compte est ajouté, vous pouvez le vérifier en listant les comptes invités "guest" de votre tenant grâce au filtre sur le "UserType" :
Get-AzureADUser -Filter "UserType eq 'Guest'"