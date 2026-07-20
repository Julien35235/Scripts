<#
.SYNOPSIS
    Script d'installation et de configuration automatisée de MDT (8456) sur Windows Server 2022 avec journalisation (Logs).
.DESCRIPTION
    Installe WDS, ADK Win11, WinPE Add-on et MDT. Applique le fix x86, crée le Deployment Share 
    et configure les fichiers .ini. Génère un log détaillé dans C:\Logs_MDT_Install\.
.NOTES
    Exécuter dans une session PowerShell en tant qu'Administrateur.
#>

# Requires -RunAsAdministrator

# --- 0. CONFIGURATION DU JOURNAL DE LOGS ---
$LogFolder = "C:\logs"
if (-not (Test-Path $LogFolder)) { New-Item -Path $LogFolder -ItemType Directory -Force | Out-Null }
$LogFile   = Join-Path -Path $LogFolder -ChildPath "MDT_Installation_$(Get-Date -Format 'yyyyMMdd_HHmmss').log"

function Write-Log {
    param (
        [Parameter(Mandatory=$true)][string]$Message,
        [ValidateSet("INFO", "WARNING", "ERROR", "SUCCESS")][string]$Level = "INFO"
    )
    $TimeStamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    $LogLine   = "[$TimeStamp] [$Level] $Message"
    
    # Écriture dans le fichier log
    Add-Content -Path $LogFile -Value $LogLine
    
    # Affichage console coloré
    switch ($Level) {
        "INFO"    { Write-Host $LogLine -ForegroundColor Cyan }
        "SUCCESS" { Write-Host $LogLine -ForegroundColor Green }
        "WARNING" { Write-Host $LogLine -ForegroundColor Yellow }
        "ERROR"   { Write-Host $LogLine -ForegroundColor Red }
    }
}

# Démarrage du journal
Write-Log "=== DÉBUT DU SCRIPT D'INSTALLATION ET CONFIGURATION MDT ===" "INFO"
Write-Log "Fichier de log généré : $LogFile" "INFO"

try {
    # --- 1. VARIABLES DE CONFIGURATION ---
    $StoragePath   = "D:\WDS\DeploymentShare"
    $ShareName     = "DeploymentShare$"
    $Description   = "MDT Deployment Share Windows 11"
    $TempFolder    = "C:\TempMDTInstall"

    $UrlADK        = "https://aka.ms/adkwin11"
    $UrlWinPE      = "https://aka.ms/adkwinpewin11"
    $UrlMDT        = "https://download.microsoft.com/download/3/3/9/3391A624-9169-42E1-A8A1-42CDE97E3F10/MicrosoftDeploymentToolkit_x64.msi"

    # --- 2. PRÉPARATION DE L'ENVIRONNEMENT ---
    Write-Log "[1/6] Création du dossier temporaire ($TempFolder)..." "INFO"
    New-Item -Path $TempFolder -ItemType Directory -Force | Out-Null

    # --- 3. INSTALLATION DU RÔLE WDS ---
    Write-Log "[2/6] Installation du rôle WDS (Windows Deployment Services)..." "INFO"
    $WdsInstall = Install-WindowsFeature -Name WDS -IncludeManagementTools -IncludeAllSubFeature
    if ($WdsInstall.Success) {
        Write-Log "Rôle WDS installé avec succès." "SUCCESS"
    } else {
        Write-Log "Erreur lors de l'installation du rôle WDS." "ERROR"
    }

    # --- 4. TÉLÉCHARGEMENT DES PRÉREQUIS ---
    Write-Log "[3/6] Téléchargement des composants Microsoft..." "INFO"
    $PathADK   = "$TempFolder\adksetup.exe"
    $PathWinPE = "$TempFolder\adkwinpesetup.exe"
    $PathMDT   = "$TempFolder\MDT_x64.msi"

    Write-Log " -> Téléchargement de Windows ADK..." "INFO"
    Invoke-WebRequest -Uri $UrlADK -OutFile $PathADK -UseBasicParsing
    
    Write-Log " -> Téléchargement du WinPE Add-on..." "INFO"
    Invoke-WebRequest -Uri $UrlWinPE -OutFile $PathWinPE -UseBasicParsing
    
    Write-Log " -> Téléchargement de MDT 8456..." "INFO"
    Invoke-WebRequest -Uri $UrlMDT -OutFile $PathMDT -UseBasicParsing

    # --- 5. INSTALLATION SILENCIEUSE DES PACKAGES ---
    Write-Log " -> Installation de Windows ADK..." "INFO"
    $ProcADK = Start-Process -FilePath $PathADK -ArgumentList "/quiet /norestart /features OptionId.DeploymentTools OptionId.ImagingAndConfigurationDesigner OptionId.UserStateMigrationTool" -Wait -PassThru
    if ($ProcADK.ExitCode -eq 0) { Write-Log "Windows ADK installé avec succès." "SUCCESS" } else { Write-Log "Échec de l'installation d'ADK (Exit code: $($ProcADK.ExitCode))." "ERROR" }

    Write-Log " -> Installation de WinPE Add-on..." "INFO"
    $ProcWinPE = Start-Process -FilePath $PathWinPE -ArgumentList "/quiet /norestart /features OptionId.WindowsPE" -Wait -PassThru
    if ($ProcWinPE.ExitCode -eq 0) { Write-Log "WinPE Add-on installé avec succès." "SUCCESS" } else { Write-Log "Échec de l'installation de WinPE Add-on (Exit code: $($ProcWinPE.ExitCode))." "ERROR" }

    Write-Log " -> Installation de MDT..." "INFO"
    $ProcMDT = Start-Process -FilePath "msiexec.exe" -ArgumentList "/i `"$PathMDT`" /quiet /norestart" -Wait -PassThru
    if ($ProcMDT.ExitCode -eq 0) { Write-Log "MDT 8456 installé avec succès." "SUCCESS" } else { Write-Log "Échec de l'installation de MDT (Exit code: $($ProcMDT.ExitCode))." "ERROR" }

    # --- 6. FIX DE COMPATIBILITÉ ADK (ARBORESCENCE X86) ---
    Write-Log "[4/6] Application du patch de compatibilité x86 pour l'ADK récent..." "INFO"
    $FixPath = "C:\Program Files (x86)\Windows Kits\10\Assessment and Deployment Kit\Windows Preinstallation Environment\x86\WinPE_OCs"
    if (-not (Test-Path $FixPath)) {
        New-Item -Path $FixPath -ItemType Directory -Force | Out-Null
        Write-Log "Dossier manquant $FixPath créé avec succès." "SUCCESS"
    } else {
        Write-Log "Le dossier $FixPath existe déjà." "INFO"
    }

    # --- 7. CRÉATION ET CONFIGURATION DU DEPLOYMENT SHARE ---
    Write-Log "[5/6] Création du Deployment Share ($StoragePath)..." "INFO"
    
    # Chargement du module PowerShell MDT
    $MdtModule = "C:\Program Files\Microsoft Deployment Toolkit\bin\MicrosoftDeploymentToolkit.psd1"
    if (Test-Path $MdtModule) {
        Import-Module $MdtModule -ErrorAction Stop
        Write-Log "Module PowerShell MDT chargé." "INFO"
    } else {
        throw "Module MDT introuvable à l'emplacement $MdtModule"
    }

    # Création du PSDrive temporaire et initialisation
    New-PSDrive -Name "DS001" -PSProvider "MDTProvider" -Root $StoragePath -Description $Description -Target $StoragePath -Force | Out-Null
    New-MDDeploymentShare -Path "DS001:" -Name $ShareName -Comments $Description -Force | Out-Null
    Write-Log "Deployment Share MDT initialisé." "SUCCESS"

    # Partage SMB
    if (-not (Get-SmbShare -Name $ShareName -ErrorAction SilentlyContinue)) {
        New-SmbShare -Name $ShareName -Path $StoragePath -FullAccess "Everyone" | Out-Null
        Write-Log "Partage réseau SMB '$ShareName' créé." "SUCCESS"
    }

    # --- 8. CONFIGURATION DES FICHIERS INI ---
    Write-Log "[6/6] Configuration des fichiers Bootstrap.ini et CustomSettings.ini..." "INFO"

    $BootstrapIniPath = "$StoragePath\Control\Bootstrap.ini"
    $BootstrapContent = @"
[Settings]
Priority=Default

[Default]
DeployRoot=\\$env:COMPUTERNAME\$ShareName
SkipBDDWelcome=YES
KeyboardLocalePE=040c:0000040c
"@
    Set-Content -Path $BootstrapIniPath -Value $BootstrapContent -Encoding UTF8
    Write-Log "Bootstrap.ini écrit dans $BootstrapIniPath" "INFO"

    $CustomSettingsIniPath = "$StoragePath\Control\CustomSettings.ini"
    $CustomSettingsContent = @"
[Settings]
Priority=Default
Properties=MyCustomProperty

[Default]
OSInstall=Y
SkipCapture=YES
SkipAdminPassword=NO
SkipProductKey=YES
SkipComputerBackup=YES
SkipBitLocker=YES
SkipUserData=YES
SkipLocaleSelection=YES
SkipTimeZone=YES
SkipSummary=NO
SkipFinalSummary=NO
UILanguage=fr-FR
UserLocale=fr-FR
KeyboardLocale=040c:0000040c
TimeZoneName=Romance Standard Time
"@
    Set-Content -Path $CustomSettingsIniPath -Value $CustomSettingsContent -Encoding UTF8
    Write-Log "CustomSettings.ini écrit dans $CustomSettingsIniPath" "INFO"

    # Nettoyage
    Remove-Item -Path $TempFolder -Recurse -Force -ErrorAction SilentlyContinue
    Write-Log "Dossier temporaire supprimé." "INFO"

    Write-Log "=== INSTALLATION ET CONFIGURATION TERMINÉES AVEC SUCCÈS ===" "SUCCESS"

} catch {
    Write-Log "UNE ERREUR CRITIQUE EST SURVENUE : $_" "ERROR"
    Write-Log "Consultez le fichier journal pour plus d'informations : $LogFile" "WARNING"
}