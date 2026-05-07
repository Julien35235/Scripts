# Répertoire à sauvegarder
$Source = "C:\Users\admin"

# Répertoire où stocker les sauvegardes
$Dest = "C:\Users\admin\Documents\Backups"

# Fichier de log
$LogFile = "C:\Logs\Backups\backup.log"

# Date du jour
$Date = Get-Date -Format "yyyy-MM-dd_HH-mm-ss"

# Nom de l’archive
$Archive = "backup_$Date.zip"

# Fonction de log (console + fichier)
function Write-Log {
    param([string]$Message)
    $Timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    $Line = "$Timestamp - $Message"
    Write-Output $Line
    Add-Content -Path $LogFile -Value $Line
}

# Début
Write-Log "Début de la sauvegarde du répertoire $Source"

# Création du dossier de sauvegarde si nécessaire
if (!(Test-Path $Dest)) {
    New-Item -ItemType Directory -Path $Dest | Out-Null
    Write-Log "Dossier créé : $Dest"
} else {
    Write-Log "Dossier de destination vérifié : $Dest"
}

# Création de la sauvegarde
try {
    Compress-Archive -Path $Source -DestinationPath "$Dest\$Archive" -Force
    Write-Log "Sauvegarde réussie : $Dest\$Archive"
}
catch {
    Write-Log "ERREUR : La sauvegarde a échoué - $($_.Exception.Message)"
    exit 1
}

Write-Log "Fin de la sauvegarde"
