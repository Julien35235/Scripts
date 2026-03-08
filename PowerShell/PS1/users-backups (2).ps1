cls
# Se déplacer dans le dossier Users
cd C:\Users\
# Affichage de la création du répertoire  
# -Get-ChildItem -Path $folderPath.CreationTime
# classement par date ordre décroisement des répétoires de chaque utilisateurs
Get-ChildItem C:\Users | Sort-Object -Property LastWriteTime -Descending
# Afficher la liste des users
# -Get-ChildItem | Select-Object Name
pause
# Choisiez le profil à sauvegarder
$profilname = Read-Host "Entrez le nom du profil à sauvegarder"
$profilname
pause
# Selectionner un user parmi cette liste suivante :
#Get-ChildItem | Where-Object {$_.Name -eq "$profilname" } | Select-Object FullName
Pause
# Parcourrir le contenu du répétoire user en excluant le répétoire onedrive et le stocker dans la varriable contenu
# -$contenu = Get-ChildItem -Recurse -Path  "C:\Users\$profilname" | Where-Object {$_.Name -notmatch "OneDrive"}
# Creer le chemin de destination
New-Item -Path "C:\Users1\" -Name "$profilname" -ItemType Directory
# Entrez le chemin de destination
$compte = "C:\Users\$profilname"
$destination = "C:\Users1\$profilname"
$destination
pause
# Chemin du fichier log
# Pour éviter que le fichier logs.log soit écrasé à chaque exécution, tu peux le rendre unique avec la date :
$logFile = "C:\Logs\BackupLogs\Backup_$profilname_$(Get-Date -Format 'yyyyMMdd_HHmmss').log" 
# Sauvegarder le profil en utilisant la commande robocopy en exluant le répetoire du dossier de OneDrive et 
# écrire dans les fichiers log en utilisant la variable $logFile 
Robocopy $compte $destination /MIR /XD "$compte\OneDrive" /XA:SH /XJD /W:5 /R:3 /MT:32 /V /TEE /LOG:"$logFile"
Write-Host "La sauvegarde du profil est terminer. Les log sont disponible ici : $logFile"


