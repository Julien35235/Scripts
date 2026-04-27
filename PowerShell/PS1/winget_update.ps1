# ================================
# Winget Update & Upgrade Script
# ================================

# Dossier de logs
$LogDir = "C:\Logs\Winget"
if (!(Test-Path $LogDir)) {
    New-Item -ItemType Directory -Path $LogDir | Out-Null
}

# Fichier de log horodaté
$Date = Get-Date -Format "yyyy-MM-dd_HH-mm-ss"
$LogFile = "$LogDir\winget_update_$Date.log"

# Fonction de logging
function Write-Log {
    param (
        [string]$Message
    )
    $Timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    $Line = "$Timestamp - $Message"
    $Line | Tee-Object -FilePath $LogFile -Append
}

Write-Log "===== DÉMARRAGE MISE À JOUR WINGET ====="

# Vérification winget
if (!(Get-Command winget -ErrorAction SilentlyContinue)) {
    Write-Log "ERREUR : winget n'est pas installé ou non disponible dans le PATH."
    exit 1
}

# Mise à jour des sources winget
Write-Log "Mise à jour des sources winget..."
winget source update 2>&1 | Tee-Object -FilePath $LogFile -Append
Write-Log "Sources winget mises à jour."

# Upgrade de tous les packages
Write-Log "Début de winget upgrade --all ..."
winget upgrade --all --accept-package-agreements --accept-source-agreements 2>&1 |
    Tee-Object -FilePath $LogFile -Append

$ExitCode = $LASTEXITCODE
Write-Log "winget upgrade terminé avec code retour : $ExitCode"

Write-Log "===== FIN MISE À JOUR WINGET ====="
exit $ExitCode