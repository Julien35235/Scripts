cls
# Se déplacer dans le dossier Users
cd C:\Users\
#Affichage de la création du répertoire  
#Get-ChildItem -Path $folderPath.CreationTime
# classement par date ordre décroisement des répétoires de chaque utilisateurs 
Get-ChildItem C:\Users | Sort-Object -Property LastWriteTime -Descending
# Afficher la liste des users 
# Get-ChildItem | Select-Object Name
pause
# Choisiez le profil à sauvegarder 
$profilname = Read-Host "Entrez le nom du profil à sauvegarder"
$profilname
pause
#Selectionner un user parmi cette liste suivante
Get-ChildItem | Where-Object {$_.Name -eq "$profilname" } | Select-Object FullName
Pause
# Parcourrir le contenu du répétoire user en excluant le répétoire onedrive et le stocker dans la varriable contenu
#$contenu = Get-ChildItem -Recurse -Path  "C:\Users\$profilname" | Where-Object {$_.Name -notmatch "OneDrive"}
# Creer le chemin de destination 
New-Item -Path "C:\Users1\" -Name "$profilname" -ItemType Directory
# Entrez le chemin de destination
$compte = "C:\Users\$profilname"
$destination = "C:\Users1\$profilname"
$destination
pause
# La sauvegarder du profil en utilisant robocopy
#Robocopy $contenu $destination /MIR /Z /XA:SH /W:5 /R:3 /XJD /MT32 /V /N
#Robocopy $compte  $destination /MIR /Z /XA:SH /W:5 /R:3 /XJD /MT32 /V /NP
#Eviter de copier le contenu du répetoire du contenu de OneDrive
Robocopy $compte $destination /MIR /XD "$compte\OneDrive" /XA:SH /XJD /W:5 /R:3 /MT:32 /V /NP
Write-Host "La sauvegarde du profil est terminer. Les log sont disponible ici : $logPath" -ForegroundColor Green
# Créer le dossier de logs s'il n'existe pas
$logDir = "C:\Logs\ProfilBackup"
if (-Not (Test-Path $logDir)) {
    New-Item -Path $logDir -ItemType Directory | Out-Null
}

 

# Générer le nom du fichier log avec horodatage
$timestamp = Get-Date -Format "yyyy-MM-dd_HH-mm-ss"
$logPath = "$logDir\Backup_$profilname`_$timestamp.log"

 

 

 
