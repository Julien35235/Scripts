# Désactiver l’utilisateur de TestUser
Disable-LocalUser -Name "TestUser"
#Vérifier que l’utilisateur est désactivé
Get-LocalUser -Name "TestUser"
#Réactiver l’utilisateur TestUser
Enable-LocalUser -Name "TestUser"
Get-LocalUser -Name "TestUser"