#Creation de la variable Password et lecture d'une saisie de utilisateur
$Password = Read-Host -AsSecureString "Entrez le mot de passe pour TestUser"
#Creation d'un utilisateur en lui mettant un password
New-LocalUser -Name "TestUser" -Password $Password -FullName "Utilisateur de test" -Description "Compte local de test"
#Ajoute du nouveau utilisataeur au groupe Administrators
Add-LocalGroupMember -Group "Administrators" -Member "TestUser"
#Verification des groupes Administrators
Get-LocalGroupMember -Group "Administrators"
# Ajoute, affiche ou modifie des groupes locaux
net localgroup Administrators
