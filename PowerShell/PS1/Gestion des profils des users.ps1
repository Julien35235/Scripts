# Choisiez le profil à sauvegarder 
$profilname = Read-Host "Entrez le nom du profil à sauvegarder"
$profilname
pause
# Se déplacer dans le dossier Users
cd C:\Users\
# Afficher la liste des users 
Get-ChildItem | Select-Object Name
#Selectionner un user parmi cette liste suivante
Get-ChildItem | Where-Object {$_.Name -eq "A_Julien" } | Select-Object FullName
Pause
# Parcourrir le contenu du répétoire user en excluant le répétoire onedrive et le stocker dans la varriable contenu
$contenu = Get-ChildItem -Recurse -Path  "C:\Users\A_Julien" | Where-Object {$_.Name -notmatch "OneDrive"}
# Entrez le chemin de destination 
$destination = "C:\Users1\$profilename"
# La sauvegarder du profil en utilisant robocopy
Robocopy $contenu $destination /MIR /L /Z /XA:H /W:5 /R:3

 