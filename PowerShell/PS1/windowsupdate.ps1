# =========================================================
# Script : Install-WindowsUpdates.ps1
# Description : Liste puis installe les mises à jour Windows
#               Update avec journalisation complète
# =========================================================

# ---------- Variables ----------
$LogFolder = "C:\Logs\WindowsUpdate"
$LogFile = "$LogFolder\WindowsUpdate_$(Get-Date -Format 'yyyyMMdd_HHmmss').log"

# ---------- Création du dossier de logs ----------
if (-not (Test-Path $LogFolder)) {
    New-Item -ItemType Directory -Path $LogFolder -Force | Out-Null
}

# ---------- Démarrage du log ----------
Start-Transcript -Path $LogFile -Append
Write-Host "===== DÉBUT WINDOWS UPDATE =====" -ForegroundColor Cyan
Write-Host "Date : $(Get-Date)"

try {
    # ---------- Execution Policy (session uniquement) ----------
    Set-ExecutionPolicy -ExecutionPolicy Bypass -Scope Process -Force

    # ---------- Installation du module PSWindowsUpdate ----------
    if (-not (Get-Module -ListAvailable -Name PSWindowsUpdate)) {
        Write-Host "Installation du module PSWindowsUpdate..."
        Install-Module -Name PSWindowsUpdate -Force -Confirm:$false -ErrorAction Stop
    }

    # ---------- Import du module ----------
    Import-Module PSWindowsUpdate -Force

    # ---------- LISTE DES MISES À JOUR ----------
    Write-Host "Recherche des mises à jour disponibles..." -ForegroundColor Yellow
    Get-WindowsUpdate -Verbose

    # ---------- INSTALLATION DES MISES À JOUR ----------
    Write-Host "Installation des mises à jour Windows Update..." -ForegroundColor Yellow
    Install-WindowsUpdate `
        -AcceptAll `
        -AutoReboot `
        -Verbose

    Write-Host "Mises à jour installées."
}
catch {
    Write-Error "ERREUR : $_"
}
finally {
    Write-Host "===== FIN WINDOWS UPDATE =====" -ForegroundColor Green
    Stop-Transcript
}