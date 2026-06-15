#Requires -Version 5.1

<#
.SYNOPSIS
    Script de mise à jour automatique des applications via WinGet
.DESCRIPTION
    Met à jour toutes les applications installées via WinGet
.AUTHOR
    Votre Nom
.VERSION
    1.0
#>

# ============================================================
#  CONFIGURATION
# ============================================================
$LogFolder  = "$env:USERPROFILE\Logs\WinGet"
$LogFile    = "$LogFolder\WinGet_Upgrade_$(Get-Date -Format 'yyyy-MM-dd_HH-mm-ss').log"
$MaxLogDays = 30   # Supprime les logs de plus de 30 jours

# ============================================================
#  FONCTIONS
# ============================================================
function Write-Log {
    param(
        [string]$Message,
        [ValidateSet("INFO","WARN","ERROR","SUCCESS")]
        [string]$Level = "INFO"
    )

    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    $line      = "[$timestamp] [$Level] $Message"

    # Couleur dans la console
    switch ($Level) {
        "INFO"    { Write-Host $line -ForegroundColor Cyan    }
        "WARN"    { Write-Host $line -ForegroundColor Yellow  }
        "ERROR"   { Write-Host $line -ForegroundColor Red     }
        "SUCCESS" { Write-Host $line -ForegroundColor Green   }
    }

    # Écriture dans le fichier log
    Add-Content -Path $LogFile -Value $line -Encoding UTF8
}

function Test-WinGet {
    try {
        $null = Get-Command winget -ErrorAction Stop
        return $true
    } catch {
        return $false
    }
}

function Remove-OldLogs {
    Get-ChildItem -Path $LogFolder -Filter "*.log" -ErrorAction SilentlyContinue |
        Where-Object { $_.LastWriteTime -lt (Get-Date).AddDays(-$MaxLogDays) } |
        ForEach-Object {
            Remove-Item $_.FullName -Force
            Write-Log "Ancien log supprimé : $($_.Name)" -Level WARN
        }
}

# ============================================================
#  MAIN
# ============================================================
Clear-Host

Write-Host "=============================================" -ForegroundColor Magenta
Write-Host "      WinGet Auto-Upgrade - v1.0             " -ForegroundColor Magenta
Write-Host "=============================================" -ForegroundColor Magenta
Write-Host ""

# Création du dossier de logs
if (-not (Test-Path $LogFolder)) {
    New-Item -ItemType Directory -Path $LogFolder -Force | Out-Null
}

# Nettoyage des anciens logs
Remove-OldLogs

Write-Log "=== Démarrage du script de mise à jour ===" -Level INFO
Write-Log "Utilisateur : $env:USERNAME | Machine : $env:COMPUTERNAME" -Level INFO
Write-Log "Log enregistré dans : $LogFile" -Level INFO

# Vérification de WinGet
Write-Log "Vérification de WinGet..." -Level INFO

if (-not (Test-WinGet)) {
    Write-Log "WinGet n'est pas installé ou introuvable !" -Level ERROR
    Write-Log "Installez 'App Installer' depuis le Microsoft Store." -Level ERROR
    Read-Host "`nAppuyez sur Entrée pour quitter"
    exit 1
}

$wingetVersion = winget --version
Write-Log "WinGet détecté : $wingetVersion" -Level SUCCESS

# Affichage des mises à jour disponibles
Write-Log "Recherche des mises à jour disponibles..." -Level INFO
Write-Host ""

winget upgrade 2>&1 | Tee-Object -FilePath $LogFile -Append

Write-Host ""
Write-Log "Lancement de la mise à jour de toutes les applications..." -Level INFO
Write-Host ""

# Lancement de la commande principale
$startTime = Get-Date

winget upgrade `
    --all `
    --include-unknown `
    --disable-interactivity `
    --accept-source-agreements `
    --accept-package-agreements 2>&1 | Tee-Object -FilePath $LogFile -Append

$exitCode  = $LASTEXITCODE
$endTime   = Get-Date
$duration  = $endTime - $startTime

Write-Host ""
Write-Log "=== Résumé ===" -Level INFO
Write-Log "Durée totale    : $([math]::Round($duration.TotalMinutes, 2)) minute(s)" -Level INFO
Write-Log "Code de retour  : $exitCode" -Level INFO

if ($exitCode -eq 0) {
    Write-Log "Toutes les mises à jour ont été appliquées avec succès !" -Level SUCCESS
} else {
    Write-Log "Le processus s'est terminé avec le code : $exitCode (certaines MAJ ont pu échouer)" -Level WARN
}

Write-Log "Log complet disponible : $LogFile" -Level INFO
Write-Host ""
Write-Host "=============================================" -ForegroundColor Magenta
Write-Host "              Script terminé                 " -ForegroundColor Magenta
Write-Host "=============================================" -ForegroundColor Magenta

Read-Host "`nAppuyez sur Entrée pour quitter"