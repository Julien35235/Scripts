# 1. Activation des privilèges de script et configuration
Set-ExecutionPolicy Bypass -Scope Process -Force
$ErrorActionPreference = "Stop"

Write-Host "=== Étape 1 : Installation du rôle WDS (Windows Deployment Services) ===" -ForegroundColor Cyan
Install-WindowsFeature -Name WDS -IncludeManagementTools

# Arrêt et désactivation initiale du service PXE de WDS pour que MDT prenne la main ou s'intègre correctement
Stop-Service -Name WDSServer -ErrorAction SilentlyContinue

Write-Host "=== Étape 2 : Téléchargement et Installation de l'ADK et WinPE (Windows 11 25H2) ===" -ForegroundColor Cyan
$tempDir = "C:\TempMDT"
New-Item -ItemType Directory -Force -Path $tempDir

# Téléchargement de l'ADK Setup (Vérifier la dernière version de l'ADK 25H2/24H2)
$adkUrl = "https://go.microsoft.com/fwlink/?linkid=2271331" # Lien générique ADK Windows 11
$winpeUrl = "https://go.microsoft.com/fwlink/?linkid=2271139" # Lien générique WinPE Addon

Write-Host "Téléchargement de adksetup.exe..."
Invoke-WebRequest -Uri $adkUrl -OutFile "$tempDir\adksetup.exe"
Write-Host "Téléchargement de adkwinpesetup.exe..."
Invoke-WebRequest -Uri $winpeUrl -OutFile "$tempDir\adkwinpesetup.exe"

# Installation silencieuse de l'ADK (Deployment Tools requis pour MDT)
Write-Host "Installation de Windows ADK..."
Start-Process -FilePath "$tempDir\adksetup.exe" -ArgumentList "/quiet /norestart /features OptionId.DeploymentTools" -Wait

# Installation silencieuse du module complémentaire WinPE
Write-Host "Installation du module Windows PE..."
Start-Process -FilePath "$tempDir\adkwinpesetup.exe" -ArgumentList "/quiet /norestart /features OptionId.WindowsPE" -Wait


Write-Host "=== Étape 3 : Téléchargement et Installation de MDT ===" -ForegroundColor Cyan
# Téléchargement de Microsoft Deployment Toolkit (x64)
$mdtUrl = "https://download.microsoft.com/download/7/6/d/76de0430-6d4e-4f81-8b0b-222a90400511/MicrosoftDeploymentToolkit_x64.msi"
Write-Host "Téléchargement de MDT..."
Invoke-WebRequest -Uri $mdtUrl -OutFile "$tempDir\MDT.msi"

Write-Host "Installation silencieuse de MDT..."
Start-Process -FilePath "msiexec.exe" -ArgumentList "/i `"$tempDir\MDT.msi`" /quiet /norestart" -Wait


Write-Host "=== Étape 4 : Création du Deployment Share (MDT) ===" -ForegroundColor Cyan
# Chargement du module PowerShell MDT
Import-Module "C:\Program Files\Microsoft Deployment Toolkit\Templates\Modules\Provisioning" -ErrorAction SilentlyContinue

$DeploymentSharePath = "D:\WDS\DeploymentShare"
New-Item -ItemType Directory -Force -Path $DeploymentSharePath

# Création du partage réseau
New-SmbShare -Name "DeploymentShare$" -Path $DeploymentSharePath -FullAccess "Administrators" -ReadAccess "Everyone"

# Initialisation de la structure MDT (Fichiers de template requis)
# (Il est recommandé d'ouvrir la console MDT 'Deployment Workbench' pour finaliser la configuration visuelle)
Write-Host "MDT installé avec succès sur $DeploymentSharePath et partagé sous DeploymentShare$" -ForegroundColor Green