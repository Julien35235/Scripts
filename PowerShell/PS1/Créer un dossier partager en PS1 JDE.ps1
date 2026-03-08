#Comment créer un dossier partager en PS1

# Création du dossier partager 
New-Item -Name "dossierpartager" -ItemType Directory
Get-ChildItem 


# Ceéation du partage 
New-SmbShare -Name dossierpartager -Path C:\dossierpartager -FullAccess Administrateurs 

#Gérez vos droits de partage 
Grant-SmbShareAccess -Name dossierpartager -AccountName "Tout le monde" -AccessRight Read

# Voir les droits d'accées 
Get-SmbShareAccess

