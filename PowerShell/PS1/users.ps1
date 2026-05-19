#Création d'un utilisateur en local
 $AccountName = "test-tssr"
$AccountPassword = ConvertTo-SecureString "P@ssw0rd123!" -AsPlainText -Force
$AccountDescription = "Compte de test"

# Créer le compte local
New-LocalUser $AccountName -Password $AccountPassword -FullName $AccountName -Description $AccountDescription
#Ce nouveau compte apparaît bien dans la liste des comptes locaux
Get-LocalUser
#Pour obtenir ces informations pour tous les comptes
Get-LocalUser | Select-Object *
Get-LocalUser -Name "test-tssr" | Select-Object *
#Rajouter l'utilisateur au groupe "Administrateuré"
Add-LocalGroupMember -Group "Administrateurs" -Member "test-tssr"
#Lister les membres du groupe "Administrateurs"
Get-LocalGroupMember -Group "Administrateurs"
#Désactiver le compte "Administrateur" sur la machine
#Disable-LocalUser -Name "Administrateur"
#Gestion des groupes locaux
Get-LocalGroup
