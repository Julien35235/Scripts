#Creation de la variable nom et age 
$nomUtilisateur = "TSSR"
$age = 30
#Afficher les variables dans la console en PowerShell.
Write-Host "Nom d'utilisateur : $nomUtilisateur"
Write-Host "Âge : $age"
$nomUtilisateur = Read-Host "Entrez votre prénom"
$age = Read-Host "Entrez votre age"
#affichage du message de bienvenu
Write-Output "Bonjour $nomUtilisateur, tu as $age ans."


