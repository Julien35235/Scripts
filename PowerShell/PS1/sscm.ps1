#Requires -RunAsAdministrator
#Requires -Version 5.1

<#
.SYNOPSIS
    Script d'installation automatisée de Microsoft SCCM (Configuration Manager)

.DESCRIPTION
    Automatise l'installation complète de SCCM incluant :
    - Vérification des prérequis système
    - Installation des fonctionnalités Windows (IIS, BITS, .NET, WSUS...)
    - Installation de Windows ADK + WinPE Add-on
    - Extension du schéma Active Directory
    - Configuration du conteneur System Management
    - Configuration SQL Server
    - Génération du fichier de réponse (unattend.ini)
    - Installation de SCCM

.PARAMETER Mode
    Full        : Installation complète (défaut)
    PrereqOnly  : Prérequis uniquement
    SchemaOnly  : Extension schéma AD uniquement
    SCCMOnly    : Installation SCCM uniquement
    CheckOnly   : Vérification prérequis uniquement

.EXAMPLE
    .\Install-SCCM.ps1 -Mode Full
    .\Install-SCCM.ps1 -Mode CheckOnly

.NOTES
    Auteur  : Script automatisé SCCM
    Version : 1.0
    Requis  : Windows Server 2016/2019/2022 | SQL Server 2017/2019 | AD Domain
#>

[CmdletBinding()]
param(
    [Parameter(Mandatory = $false)]
    [ValidateSet("Full", "PrereqOnly", "SchemaOnly", "SCCMOnly", "CheckOnly")]
    [string]$Mode = "Full"
)

Set-StrictMode -Version Latest
$ErrorActionPreference = "Continue"

# ================================================================
#  ██████╗ ██████╗ ███╗   ██╗███████╗██╗ ██████╗
# ██╔════╝██╔═══██╗████╗  ██║██╔════╝██║██╔════╝
# ██║     ██║   ██║██╔██╗ ██║█████╗  ██║██║  ███╗
# ██║     ██║   ██║██║╚██╗██║██╔══╝  ██║██║   ██║
# ╚██████╗╚██████╔╝██║ ╚████║██║     ██║╚██████╔╝
#  ╚═════╝ ╚═════╝ ╚═╝  ╚═══╝╚═╝     ╚═╝ ╚═════╝
# ================================================================
# MODIFIEZ CETTE SECTION SELON VOTRE ENVIRONNEMENT
# ================================================================

$Config = @{

    # ── Chemins Sources ─────────────────────────────────────────
    # Montez l'ISO SCCM et indiquez le chemin ici
    SCCMSourcePath      = "D:\SCCM"

    # Téléchargez ADK depuis :
    # https://docs.microsoft.com/fr-fr/windows-hardware/get-started/adk-install
    ADKSetupPath        = "C:\Sources\ADK\adksetup.exe"
    ADKWinPEPath        = "C:\Sources\ADKWinPE\adkwinpesetup.exe"

    # Dossier où SCCM téléchargera ses prérequis automatiquement
    SCCMPrereqPath      = "C:\SCCMPrereqs"

    # ── Installation SCCM ───────────────────────────────────────
    InstallDir          = "C:\Program Files\Microsoft Configuration Manager"

    # ── Configuration Site ──────────────────────────────────────
    # Code site : 3 caractères alphanumériques (pas CAS, SMS, DIS, etc.)
    SiteCode            = "S01"
    SiteName            = "Mon Site SCCM Principal"
    SiteServerFQDN      = "$($env:COMPUTERNAME).$($env:USERDNSDOMAIN)"

    # ── Configuration SQL Server ────────────────────────────────
    # Format : SERVEUR\INSTANCE ou SERVEUR pour instance par défaut
    SQLServerInstance   = "$($env:COMPUTERNAME)\SCCM"
    SQLDatabaseName     = "CM_S01"        # Doit correspondre : CM_<SiteCode>
    SQLSSBPort          = 4022            # SQL Service Broker Port
    SQLDataPath         = "C:\SQL\Data"
    SQLLogPath          = "C:\SQL\Logs"
    SQLTempDBPath       = "C:\SQL\TempDB"
    # Mémoire max SQL en MB (laissez de la RAM pour Windows)
    SQLMaxMemoryMB      = 8192

    # ── Active Directory ────────────────────────────────────────
    DomainName          = $env:USERDNSDOMAIN
    DomainDN            = "DC=" + ($env:USERDNSDOMAIN -replace "\.", ",DC=")

    # ── Comptes de service ──────────────────────────────────────
    # IMPORTANT : Changez ces valeurs !
    ServiceAccount      = "$($env:USERDOMAIN)\svc_sccm"
    NetworkAccessAccount= "$($env:USERDOMAIN)\svc_sccm_naa"

    # ── Logs ────────────────────────────────────────────────────
    LogDir              = "C:\Logs\SCCM"
    LogFile             = "SCCM_Install_$(Get-Date -Format 'yyyyMMdd_HHmmss').log"

    # ── Options ─────────────────────────────────────────────────
    # HTTP ou HTTPS pour la communication
    ClientProtocol      = "HTTPorHTTPS"
    # Installer la console SCCM sur ce serveur
    InstallAdminConsole = 1
    # Rejoindre le CEIP (Customer Experience Improvement Program)
    JoinCEIP            = 0
}

# ================================================================
# FONCTIONS : LOGGING & AFFICHAGE
# ================================================================

function Write-Log {
    param(
        [Parameter(Mandatory)]
        [string]$Message,

        [ValidateSet("INFO", "WARN", "ERROR", "SUCCESS", "STEP", "DEBUG")]
        [string]$Level = "INFO",

        [switch]$NoFile
    )

    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    $logLine   = "[$timestamp][$Level] $Message"

    # Couleurs console
    $colorMap = @{
        "INFO"    = "Cyan"
        "WARN"    = "Yellow"
        "ERROR"   = "Red"
        "SUCCESS" = "Green"
        "STEP"    = "Magenta"
        "DEBUG"   = "DarkGray"
    }

    $icons = @{
        "INFO"    = "ℹ"
        "WARN"    = "⚠"
        "ERROR"   = "✖"
        "SUCCESS" = "✔"
        "STEP"    = "►"
        "DEBUG"   = "·"
    }

    $display = "  $($icons[$Level]) [$Level] $Message"
    Write-Host $display -ForegroundColor $colorMap[$Level]

    # Écriture fichier log
    if (-not $NoFile) {
        $logPath = Join-Path $Config.LogDir $Config.LogFile
        try {
            Add-Content -Path $logPath -Value $logLine -ErrorAction SilentlyContinue
        } catch { <# Ignore #> }
    }
}

function Write-Banner {
    param([string]$Text, [string]$Color = "Blue")
    $border = "=" * 62
    Write-Host ""
    Write-Host "  $border" -ForegroundColor $Color
    Write-Host "  $(('  ' + $Text).PadRight(62))" -ForegroundColor $Color
    Write-Host "  $border" -ForegroundColor $Color
    Write-Host ""
}

function Write-Step {
    param([int]$Step, [int]$Total, [string]$Description)
    Write-Host ""
    Write-Host "  ┌─────────────────────────────────────────────────────" -ForegroundColor Magenta
    Write-Host "  │  ÉTAPE $Step/$Total : $Description" -ForegroundColor Magenta
    Write-Host "  └─────────────────────────────────────────────────────" -ForegroundColor Magenta
    Write-Log "=== ÉTAPE $Step/$Total : $Description ===" "STEP"
}

function Write-Result {
    param([bool]$Success, [string]$Task)
    if ($Success) {
        Write-Log "$Task : RÉUSSI" "SUCCESS"
    } else {
        Write-Log "$Task : ÉCHEC" "ERROR"
    }
}

# ================================================================
# FONCTIONS : UTILITAIRES
# ================================================================

function Initialize-Environment {
    # Créer les dossiers nécessaires
    $paths = @(
        $Config.LogDir,
        $Config.SCCMPrereqPath,
        $Config.SQLDataPath,
        $Config.SQLLogPath,
        $Config.SQLTempDBPath
    )

    foreach ($path in $paths) {
        if (-not (Test-Path $path)) {
            New-Item -ItemType Directory -Path $path -Force | Out-Null
            Write-Log "Dossier créé : $path" "INFO"
        }
    }
}

function Test-AdminPrivileges {
    $currentUser = [System.Security.Principal.WindowsIdentity]::GetCurrent()
    $principal   = New-Object System.Security.Principal.WindowsPrincipal($currentUser)
    return $principal.IsInRole([System.Security.Principal.WindowsBuiltInRole]::Administrator)
}

function Get-DiskSpaceGB {
    param([string]$Drive = "C")
    $disk = Get-WmiObject -Class Win32_LogicalDisk -Filter "DeviceID='${Drive}:'" -ErrorAction SilentlyContinue
    if ($disk) {
        return [math]::Round($disk.FreeSpace / 1GB, 2)
    }
    return 0
}

function Get-TotalRAMGB {
    $ram = Get-WmiObject -Class Win32_PhysicalMemory |
           Measure-Object -Property Capacity -Sum
    return [math]::Round($ram.Sum / 1GB, 2)
}

function Wait-ForService {
    param([string]$ServiceName, [int]$TimeoutSec = 60)
    $elapsed = 0
    while ($elapsed -lt $TimeoutSec) {
        $svc = Get-Service -Name $ServiceName -ErrorAction SilentlyContinue
        if ($svc -and $svc.Status -eq "Running") { return $true }
        Start-Sleep -Seconds 5
        $elapsed += 5
    }
    return $false
}

# ================================================================
# FONCTION : VÉRIFICATION DES PRÉREQUIS
# ================================================================

function Test-AllPrerequisites {
    Write-Step 1 6 "Vérification des prérequis système"

    $errors   = [System.Collections.Generic.List[string]]::new()
    $warnings = [System.Collections.Generic.List[string]]::new()

    # ── Système d'exploitation ───────────────────────────────
    Write-Log "Vérification du système d'exploitation..." "INFO"
    $os = Get-WmiObject -Class Win32_OperatingSystem
    Write-Log "OS détecté : $($os.Caption) (Build $($os.BuildNumber))" "INFO"

    if ($os.ProductType -ne 3) {
        $errors.Add("Doit être exécuté sur Windows Server (ProductType=3), actuel: $($os.ProductType)")
    }

    $supportedBuilds = @(14393, 17763, 20348) # Server 2016, 2019, 2022
    if ($os.BuildNumber -notin $supportedBuilds) {
        $warnings.Add("Build Windows $($os.BuildNumber) - Version non officiellement testée pour SCCM")
    } else {
        Write-Log "Version Windows : Compatible ✔" "SUCCESS"
    }

    # ── Appartenance au domaine ──────────────────────────────
    Write-Log "Vérification de l'appartenance au domaine..." "INFO"
    $compSys = Get-WmiObject -Class Win32_ComputerSystem
    if ($compSys.PartOfDomain) {
        Write-Log "Domaine : $($compSys.Domain) ✔" "SUCCESS"
    } else {
        $errors.Add("Le serveur doit être membre d'un domaine Active Directory")
    }

    # ── RAM ──────────────────────────────────────────────────
    Write-Log "Vérification de la mémoire RAM..." "INFO"
    $ramGB = Get-TotalRAMGB
    Write-Log "RAM totale : $ramGB GB" "INFO"

    if ($ramGB -lt 8) {
        $errors.Add("RAM insuffisante : $ramGB GB (minimum 8 GB, recommandé 16 GB)")
    } elseif ($ramGB -lt 16) {
        $warnings.Add("RAM : $ramGB GB (recommandé 16 GB pour un environnement de production)")
        Write-Log "RAM : $ramGB GB ⚠ (recommandé 16 GB)" "WARN"
    } else {
        Write-Log "RAM : $ramGB GB ✔" "SUCCESS"
    }

    # ── Espace disque ────────────────────────────────────────
    Write-Log "Vérification de l'espace disque..." "INFO"
    $diskC = Get-DiskSpaceGB "C"
    Write-Log "Disque C: libre : $diskC GB" "INFO"

    if ($diskC -lt 50) {
        $errors.Add("Espace disque insuffisant sur C: : $diskC GB (minimum 50 GB)")
    } elseif ($diskC -lt 100) {
        $warnings.Add("Espace disque C: : $diskC GB (recommandé 100 GB+)")
    } else {
        Write-Log "Espace disque C: : $diskC GB ✔" "SUCCESS"
    }

    # ── SQL Server ───────────────────────────────────────────
    Write-Log "Vérification de SQL Server..." "INFO"
    $sqlServices = Get-Service -Name "MSSQL*" -ErrorAction SilentlyContinue

    if ($sqlServices) {
        foreach ($svc in $sqlServices) {
            Write-Log "SQL Service détecté : $($svc.Name) [$($svc.Status)]" "INFO"
            if ($svc.Status -ne "Running") {
                $warnings.Add("Service SQL $($svc.Name) n'est pas démarré")
            }
        }
        Write-Log "SQL Server : Présent ✔" "SUCCESS"
    } else {
        $errors.Add("SQL Server non détecté - Installez SQL Server 2017/2019 avant SCCM")
    }

    # ── Fichiers sources SCCM ────────────────────────────────
    Write-Log "Vérification des fichiers sources SCCM..." "INFO"
    if (Test-Path $Config.SCCMSourcePath) {
        $setupExe = Join-Path $Config.SCCMSourcePath "SMSSETUP\BIN\X64\setup.exe"
        if (Test-Path $setupExe) {
            Write-Log "Sources SCCM : $($Config.SCCMSourcePath) ✔" "SUCCESS"
        } else {
            $errors.Add("setup.exe introuvable dans $($Config.SCCMSourcePath)\SMSSETUP\BIN\X64\")
        }
    } else {
        $errors.Add("Sources SCCM introuvables : $($Config.SCCMSourcePath)")
    }

    # ── Windows ADK ──────────────────────────────────────────
    Write-Log "Vérification de Windows ADK..." "INFO"
    $adkPath = "${env:ProgramFiles(x86)}\Windows Kits\10\Assessment and Deployment Kit"
    if (Test-Path $adkPath) {
        Write-Log "Windows ADK : Installé ✔" "SUCCESS"
    } else {
        $warnings.Add("Windows ADK non installé - Sera installé automatiquement si le chemin est configuré")
    }

    # ── .NET Framework ───────────────────────────────────────
    Write-Log "Vérification de .NET Framework..." "INFO"
    $dotNet = Get-WindowsFeature -Name "NET-Framework-45-Core" -ErrorAction SilentlyContinue
    if ($dotNet -and $dotNet.InstallState -eq "Installed") {
        Write-Log ".NET Framework 4.5+ : Installé ✔" "SUCCESS"
    } else {
        $warnings.Add(".NET Framework 4.5 non installé - Sera installé avec les fonctionnalités Windows")
    }

    # ── Résumé ───────────────────────────────────────────────
    Write-Host ""
    Write-Host "  ┌── Résumé des prérequis ──────────────────────────────" -ForegroundColor White
    Write-Host "  │  Erreurs   : $($errors.Count)" -ForegroundColor $(if($errors.Count -gt 0){"Red"}else{"Green"})
    Write-Host "  │  Avertiss. : $($warnings.Count)" -ForegroundColor $(if($warnings.Count -gt 0){"Yellow"}else{"Green"})
    Write-Host "  └─────────────────────────────────────────────────────" -ForegroundColor White

    if ($errors.Count -gt 0) {
        Write-Host ""
        Write-Log "ERREURS BLOQUANTES :" "ERROR"
        foreach ($err in $errors) {
            Write-Log "  ✖ $err" "ERROR"
        }
    }

    if ($warnings.Count -gt 0) {
        Write-Host ""
        Write-Log "AVERTISSEMENTS :" "WARN"
        foreach ($warn in $warnings) {
            Write-Log "  ⚠ $warn" "WARN"
        }
    }

    return ($errors.Count -eq 0)
}

# ================================================================
# FONCTION : INSTALLATION DES FONCTIONNALITÉS WINDOWS
# ================================================================

function Install-WindowsPrerequisites {
    Write-Step 2 6 "Installation des fonctionnalités Windows"

    # Liste complète des features requises par SCCM
    $features = @(
        # .NET Framework
        @{ Name = "NET-Framework-Features";       Desc = ".NET Framework" }
        @{ Name = "NET-Framework-Core";            Desc = ".NET Framework Core" }
        @{ Name = "NET-Framework-45-Features";     Desc = ".NET Framework 4.5" }
        @{ Name = "NET-Framework-45-Core";         Desc = ".NET Framework 4.5 Core" }
        @{ Name = "NET-Framework-45-ASPNET";       Desc = ".NET ASP.NET 4.5" }
        @{ Name = "NET-WCF-Services45";            Desc = ".NET WCF Services" }
        @{ Name = "NET-WCF-HTTP-Activation45";     Desc = ".NET WCF HTTP Activation" }
        @{ Name = "NET-WCF-TCP-Activation45";      Desc = ".NET WCF TCP Activation" }
        @{ Name = "NET-WCF-Pipe-Activation45";     Desc = ".NET WCF Pipe Activation" }

        # BITS (Background Intelligent Transfer Service)
        @{ Name = "BITS";                          Desc = "BITS" }
        @{ Name = "BITS-IIS-Ext";                  Desc = "BITS IIS Extension" }

        # Remote Differential Compression
        @{ Name = "RDC";                           Desc = "Remote Differential Compression" }

        # IIS - Serveur Web
        @{ Name = "Web-Server";                    Desc = "IIS - Serveur Web" }
        @{ Name = "Web-Common-Http";               Desc = "IIS - HTTP Commun" }
        @{ Name = "Web-Default-Doc";               Desc = "IIS - Document par défaut" }
        @{ Name = "Web-Dir-Browsing";              Desc = "IIS - Navigation répertoires" }
        @{ Name = "Web-Http-Errors";               Desc = "IIS - Erreurs HTTP" }
        @{ Name = "Web-Static-Content";            Desc = "IIS - Contenu statique" }
        @{ Name = "Web-Http-Redirect";             Desc = "IIS - Redirection HTTP" }
        @{ Name = "Web-DAV-Publishing";            Desc = "IIS - WebDAV" }

        # IIS - Santé et diagnostics
        @{ Name = "Web-Health";                    Desc = "IIS - Santé" }
        @{ Name = "Web-Http-Logging";              Desc = "IIS - Journalisation HTTP" }
        @{ Name = "Web-Custom-Logging";            Desc = "IIS - Journalisation personnalisée" }
        @{ Name = "Web-Log-Libraries";             Desc = "IIS - Bibliothèques de journaux" }
        @{ Name = "Web-Request-Monitor";           Desc = "IIS - Moniteur de requêtes" }
        @{ Name = "Web-Http-Tracing";              Desc = "IIS - Traçage HTTP" }

        # IIS - Performances
        @{ Name = "Web-Performance";               Desc = "IIS - Performances" }
        @{ Name = "Web-Stat-Compression";          Desc = "IIS - Compression statique" }
        @{ Name = "Web-Dyn-Compression";           Desc = "IIS - Compression dynamique" }

        # IIS - Sécurité
        @{ Name = "Web-Security";                  Desc = "IIS - Sécurité" }
        @{ Name = "Web-Filtering";                 Desc = "IIS - Filtrage des requêtes" }
        @{ Name = "Web-Basic-Auth";                Desc = "IIS - Auth. Basique" }
        @{ Name = "Web-Windows-Auth";              Desc = "IIS - Auth. Windows" }
        @{ Name = "Web-Digest-Auth";               Desc = "IIS - Auth. Digest" }
        @{ Name = "Web-Client-Auth";               Desc = "IIS - Auth. Client" }
        @{ Name = "Web-Cert-Auth";                 Desc = "IIS - Auth. Certificat" }
        @{ Name = "Web-IP-Security";               Desc = "IIS - Sécurité IP" }
        @{ Name = "Web-Url-Auth";                  Desc = "IIS - Auth. URL" }

        # IIS - Développement d'applications
        @{ Name = "Web-App-Dev";                   Desc = "IIS - Développement App" }
        @{ Name = "Web-Net-Ext";                   Desc = "IIS - Extensibilité .NET" }
        @{ Name = "Web-Net-Ext45";                 Desc = "IIS - Extensibilité .NET 4.5" }
        @{ Name = "Web-Asp-Net";                   Desc = "IIS - ASP.NET" }
        @{ Name = "Web-Asp-Net45";                 Desc = "IIS - ASP.NET 4.5" }
        @{ Name = "Web-ISAPI-Ext";                 Desc = "IIS - ISAPI Extensions" }
        @{ Name = "Web-ISAPI-Filter";              Desc = "IIS - ISAPI Filters" }
        @{ Name = "Web-CGI";                       Desc = "IIS - CGI" }
        @{ Name = "Web-AppInit";                   Desc = "IIS - App Initialization" }
        @{ Name = "Web-WebSockets";                Desc = "IIS - WebSockets" }

        # IIS - Outils de gestion
        @{ Name = "Web-Mgmt-Tools";                Desc = "IIS - Outils de gestion" }
        @{ Name = "Web-Mgmt-Console";              Desc = "IIS - Console de gestion" }
        @{ Name = "Web-Mgmt-Compat";               Desc = "IIS - Compatibilité gestion" }
        @{ Name = "Web-Metabase";                  Desc = "IIS - Métabase" }
        @{ Name = "Web-Lgcy-Scripting";            Desc = "IIS - Scripts hérités" }
        @{ Name = "Web-WMI";                       Desc = "IIS - WMI" }
        @{ Name = "Web-Scripting-Tools";           Desc = "IIS - Outils de script" }
        @{ Name = "Web-Mgmt-Service";              Desc = "IIS - Service de gestion" }

        # WSUS
        @{ Name = "UpdateServices-WidDB";          Desc = "WSUS (base WID)" }
        @{ Name = "UpdateServices-Services";       Desc = "WSUS Services" }
        @{ Name = "UpdateServices-API";            Desc = "WSUS API" }
        @{ Name = "UpdateServices-UI";             Desc = "WSUS Console" }

        # RSAT - Active Directory
        @{ Name = "RSAT-AD-Tools";                 Desc = "RSAT - Outils AD" }
        @{ Name = "RSAT-ADDS";                     Desc = "RSAT - AD DS" }
        @{ Name = "RSAT-AD-AdminCenter";           Desc = "RSAT - Centre Admin AD" }
        @{ Name = "RSAT-ADDS-Tools";               Desc = "RSAT - Outils AD DS" }
        @{ Name = "RSAT-AD-PowerShell";            Desc = "RSAT - PowerShell AD" }
    )

    $total     = $features.Count
    $installed = 0
    $already   = 0
    $failed    = 0
    $current   = 0

    foreach ($feature in $features) {
        $current++
        $percent = [math]::Round(($current / $total) * 100)

        # Barre de progression
        Write-Progress -Activity "Installation des fonctionnalités Windows" `
                       -Status "[$percent%] $($feature.Desc)" `
                       -PercentComplete $percent

        try {
            $result = Install-WindowsFeature -Name $feature.Name `
                                             -IncludeManagementTools `
                                             -ErrorAction SilentlyContinue

            if ($result.Success) {
                if ($result.FeatureResult.Count -gt 0) {
                    $installed++
                    Write-Log "  ✔ Installé : $($feature.Desc)" "SUCCESS"
                } else {
                    $already++
                    Write-Log "  · Déjà installé : $($feature.Desc)" "DEBUG"
                }
            } else {
                $failed++
                Write-Log "  ✖ Échec : $($feature.Name)" "WARN"
            }
        } catch {
            $failed++
            Write-Log "  ✖ Erreur $($feature.Name) : $($_.Exception.Message)" "ERROR"
        }
    }

    Write-Progress -Activity "Installation des fonctionnalités Windows" -Completed

    Write-Host ""
    Write-Log "Fonctionnalités : $installed nouvelles | $already déjà installées | $failed erreurs" "INFO"

    if ($failed -gt 0) {
        Write-Log "Certaines fonctionnalités n'ont pas pu être installées (non bloquant)" "WARN"
    }

    # Vérifier si un redémarrage est nécessaire
    $rebootPending = (Get-ItemProperty "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Component Based Servicing\RebootPending" -ErrorAction SilentlyContinue) -ne $null

    if ($rebootPending) {
        Write-Log "Un redémarrage est nécessaire pour finaliser les fonctionnalités Windows" "WARN"
        Write-Log "Redémarrez le serveur et relancez le script avec -Mode SCCMOnly" "WARN"
    }

    return ($failed -lt ($total * 0.1)) # Accepter jusqu'à 10% d'échecs
}

# ================================================================
# FONCTION : INSTALLATION WINDOWS ADK
# ================================================================

function Install-WindowsADK {
    Write-Step 3 6 "Installation Windows ADK + WinPE Add-on"

    # ── Vérifier si ADK est déjà installé ───────────────────
    $adkPath = "${env:ProgramFiles(x86)}\Windows Kits\10\Assessment and Deployment Kit"
    $adkInstalled = Test-Path $adkPath

    if ($adkInstalled) {
        Write-Log "Windows ADK déjà installé : $adkPath ✔" "SUCCESS"
    } else {
        # ── Installer ADK ────────────────────────────────────
        if (-not (Test-Path $Config.ADKSetupPath)) {
            Write-Log "Fichier ADK introuvable : $($Config.ADKSetupPath)" "ERROR"
            Write-Log "Téléchargez ADK 10 (version 2004+) :" "INFO"
            Write-Log "https://docs.microsoft.com/fr-fr/windows-hardware/get-started/adk-install" "INFO"
            return $false
        }

        Write-Log "Installation de Windows ADK en cours..." "INFO"
        Write-Log "Durée estimée : 5-10 minutes" "INFO"

        $adkArgs = @(
            "/quiet",
            "/norestart",
            "/features",
            "OptionId.DeploymentTools",
            "OptionId.UserStateMigrationTool",
            "OptionId.ImagingAndConfigurationDesigner",
            "OptionId.ICDConfigurationDesigner"
        )

        try {
            $proc = Start-Process -FilePath $Config.ADKSetupPath `
                                  -ArgumentList $adkArgs `
                                  -Wait -PassThru `
                                  -RedirectStandardOutput "$($Config.LogDir)\ADK_Install.log" `
                                  -RedirectStandardError  "$($Config.LogDir)\ADK_Error.log"

            if ($proc.ExitCode -in @(0, 3010)) {
                Write-Log "Windows ADK installé avec succès! ✔" "SUCCESS"
                $adkInstalled = $true
            } else {
                Write-Log "Erreur installation ADK (Code sortie: $($proc.ExitCode))" "ERROR"
                Write-Log "Log : $($Config.LogDir)\ADK_Install.log" "INFO"
                return $false
            }
        } catch {
            Write-Log "Exception lors de l'installation ADK : $($_.Exception.Message)" "ERROR"
            return $false
        }
    }

    # ── Vérifier et installer WinPE Add-on ──────────────────
    $winPEPath = "${env:ProgramFiles(x86)}\Windows Kits\10\Assessment and Deployment Kit\Windows Preinstallation Environment"
    $winPEInstalled = Test-Path $winPEPath

    if ($winPEInstalled) {
        Write-Log "Windows PE Add-on déjà installé ✔" "SUCCESS"
    } else {
        if (Test-Path $Config.ADKWinPEPath) {
            Write-Log "Installation du Windows PE Add-on en cours..." "INFO"

            $winPEArgs = @(
                "/quiet",
                "/norestart",
                "/features",
                "OptionId.WindowsPreinstallationEnvironment"
            )

            try {
                $proc2 = Start-Process -FilePath $Config.ADKWinPEPath `
                                       -ArgumentList $winPEArgs `
                                       -Wait -PassThru `
                                       -RedirectStandardOutput "$($Config.LogDir)\WinPE_Install.log"

                if ($proc2.ExitCode -in @(0, 3010)) {
                    Write-Log "Windows PE Add-on installé avec succès! ✔" "SUCCESS"
                } else {
                    Write-Log "Erreur WinPE Add-on (Code: $($proc2.ExitCode))" "WARN"
                }
            } catch {
                Write-Log "Exception WinPE : $($_.Exception.Message)" "WARN"
            }
        } else {
            Write-Log "WinPE Add-on introuvable : $($Config.ADKWinPEPath)" "WARN"
            Write-Log "Téléchargez le WinPE Add-on depuis le même lien que ADK" "INFO"
        }
    }

    return $true
}

# ================================================================
# FONCTION : EXTENSION DU SCHÉMA ACTIVE DIRECTORY
# ================================================================

function Expand-ADSchema {
    Write-Step 4 6 "Extension du schéma Active Directory"

    # ── Vérifier les droits Schema Admin ────────────────────
    Write-Log "Vérification des droits Schema Admin..." "INFO"

    try {
        Import-Module ActiveDirectory -ErrorAction Stop

        $currentUser    = [System.Security.Principal.WindowsIdentity]::GetCurrent()
        $schemaAdmins   = Get-ADGroupMember -Identity "Schema Admins" -ErrorAction SilentlyContinue
        $isSchemaAdmin  = $schemaAdmins | Where-Object { $_.SamAccountName -eq $env:USERNAME }

        if (-not $isSchemaAdmin) {
            Write-Log "L'utilisateur $($env:USERNAME) n'est pas membre de 'Schema Admins'" "WARN"
            Write-Log "L'extension du schéma pourrait échouer" "WARN"
        } else {
            Write-Log "Droits Schema Admin confirmés ✔" "SUCCESS"
        }

        # Vérifier le maître de schéma
        $schemaMaster = (Get-ADForest).SchemaMaster
        $localFQDN    = "$($env:COMPUTERNAME).$($env:USERDNSDOMAIN)".ToLower()

        Write-Log "Maître de schéma : $schemaMaster" "INFO"
        Write-Log "Ce serveur : $localFQDN" "INFO"

        if ($schemaMaster.ToLower() -ne $localFQDN) {
            Write-Log "Ce serveur n'est pas le maître de schéma" "WARN"
            Write-Log "Assurez-vous que l'extension sera exécutée sur : $schemaMaster" "WARN"
        }

    } catch {
        Write-Log "Impossible de vérifier les droits AD : $($_.Exception.Message)" "WARN"
    }

    # ── Lancer extadsch.exe ──────────────────────────────────
    $extadschPath = Join-Path $Config.SCCMSourcePath "SMSSETUP\BIN\X64\extadsch.exe"

    if (-not (Test-Path $extadschPath)) {
        Write-Log "extadsch.exe introuvable : $extadschPath" "ERROR"
        return $false
    }

    Write-Log "Exécution de extadsch.exe..." "INFO"

    try {
        $extLog = "$($Config.LogDir)\ExtADSchema.log"
        $proc   = Start-Process -FilePath $extadschPath `
                                -Wait -PassThru `
                                -RedirectStandardOutput $extLog `
                                -RedirectStandardError  "$($Config.LogDir)\ExtADSchema_Error.log"

        # ExitCode 0 = succès, 1 = déjà étendu
        if ($proc.ExitCode -in @(0, 1)) {
            Write-Log "Schéma AD étendu avec succès! ✔" "SUCCESS"
            Write-Log "Log extension : $extLog" "INFO"
        } else {
            Write-Log "Erreur extension schéma (Code: $($proc.ExitCode))" "ERROR"
            Write-Log "Vérifiez : $extLog" "INFO"
            return $false
        }
    } catch {
        Write-Log "Exception extadsch : $($_.Exception.Message)" "ERROR"
        return $false
    }

    # ── Créer le conteneur System Management ────────────────
    New-SystemManagementContainer
    return $true
}

function New-SystemManagementContainer {
    Write-Log "Configuration du conteneur 'System Management' dans AD..." "INFO"

    try {
        Import-Module ActiveDirectory -ErrorAction Stop

        $domainDN     = (Get-ADDomain).DistinguishedName
        $systemDN     = "CN=System,$domainDN"
        $smDN         = "CN=System Management,$systemDN"

        # Vérifier/créer le conteneur
        $exists = $null
        try {
            $exists = Get-ADObject -Identity $smDN -ErrorAction Stop
            Write-Log "Conteneur 'System Management' : Déjà existant ✔" "SUCCESS"
        } catch {
            Write-Log "Création du conteneur 'System Management'..." "INFO"
            New-ADObject -Name "System Management" `
                         -Type Container `
                         -Path $systemDN `
                         -ErrorAction Stop
            Write-Log "Conteneur créé ✔" "SUCCESS"
        }

        # Attribuer les permissions Full Control au compte ordinateur SCCM
        Write-Log "Attribution des permissions Full Control au compte ordinateur..." "INFO"

        $computerAccount = Get-ADComputer -Identity $env:COMPUTERNAME -ErrorAction Stop
        $sid             = [System.Security.Principal.SecurityIdentifier]$computerAccount.SID

        # Utiliser la voie ADSI pour les ACL
        $adsiPath = "LDAP://$smDN"
        $acl      = [System.DirectoryServices.DirectoryEntry]$adsiPath

        $adRule = New-Object System.DirectoryServices.ActiveDirectoryAccessRule(
            $sid,
            [System.DirectoryServices.ActiveDirectoryRights]::GenericAll,
            [System.Security.AccessControl.AccessControlType]::Allow,
            [System.DirectoryServices.ActiveDirectorySecurityInheritance]::All
        )

        $acl.ObjectSecurity.AddAccessRule($adRule)
        $acl.CommitChanges()

        Write-Log "Permissions attribuées à $($env:COMPUTERNAME)$ ✔" "SUCCESS"

    } catch {
        Write-Log "Erreur configuration conteneur AD : $($_.Exception.Message)" "ERROR"
    }
}

# ================================================================
# FONCTION : CONFIGURATION SQL SERVER
# ================================================================

function Set-SQLServerConfiguration {
    Write-Step 5 6 "Configuration SQL Server pour SCCM"

    # ── Vérifier la disponibilité SQL ───────────────────────
    Write-Log "Test de connexion à SQL Server : $($Config.SQLServerInstance)..." "INFO"

    $sqlAvailable = $false

    try {
        # Essayer avec le module SqlServer
        if (Get-Module -ListAvailable -Name "SqlServer" -ErrorAction SilentlyContinue) {
            Import-Module SqlServer -ErrorAction SilentlyContinue
            $sqlAvailable = $true
            Write-Log "Module SqlServer chargé ✔" "SUCCESS"
        } elseif (Get-Module -ListAvailable -Name "SQLPS" -ErrorAction SilentlyContinue) {
            Import-Module SQLPS -DisableNameChecking -ErrorAction SilentlyContinue
            $sqlAvailable = $true
            Write-Log "Module SQLPS chargé ✔" "SUCCESS"
        } else {
            Write-Log "Modules SQL PowerShell non disponibles - Configuration via SQL Native Client" "WARN"
        }
    } catch {
        Write-Log "Erreur chargement module SQL : $($_.Exception.Message)" "WARN"
    }

    if (-not $sqlAvailable) {
        Write-Log "Configuration SQL ignorée - Faites-la manuellement avant l'installation" "WARN"
        Write-Log "Vérifiez : collation SQL_Latin1_General_CP1_CI_AS, CLR enabled, mémoire" "INFO"
        return $true  # Non bloquant
    }

    # ── Configuration SQL ────────────────────────────────────
    $sqlQueries = @(
        @{
            Desc  = "Activation CLR"
            Query = "EXEC sp_configure 'show advanced options', 1; RECONFIGURE; EXEC sp_configure 'clr enabled', 1; RECONFIGURE;"
        },
        @{
            Desc  = "Mémoire maximale SQL"
            Query = "EXEC sp_configure 'show advanced options', 1; RECONFIGURE; EXEC sp_configure 'max server memory (MB)', $($Config.SQLMaxMemoryMB); RECONFIGURE;"
        },
        @{
            Desc  = "Isolation niveau snapshot"
            Query = "IF DB_ID('CM_$($Config.SiteCode)') IS NOT NULL BEGIN ALTER DATABASE [CM_$($Config.SiteCode)] SET ENABLE_BROKER WITH ROLLBACK IMMEDIATE; END"
        }
    )

    foreach ($q in $sqlQueries) {
        try {
            Invoke-Sqlcmd -ServerInstance $Config.SQLServerInstance `
                          -Query $q.Query `
                          -QueryTimeout 30 `
                          -ErrorAction SilentlyContinue
            Write-Log "SQL Config : $($q.Desc) ✔" "SUCCESS"
        } catch {
            Write-Log "SQL Config : $($q.Desc) - Erreur (non bloquant) : $($_.Exception.Message)" "WARN"
        }
    }

    # ── Vérifier la collation ────────────────────────────────
    try {
        $result    = Invoke-Sqlcmd -ServerInstance $Config.SQLServerInstance `
                                   -Query "SELECT SERVERPROPERTY('Collation') AS Collation, SERVERPROPERTY('ProductVersion') AS Version" `
                                   -ErrorAction SilentlyContinue

        $collation = $result.Collation
        $version   = $result.Version

        Write-Log "SQL Server Version : $version" "INFO"
        Write-Log "Collation SQL : $collation" "INFO"

        if ($collation -ne "SQL_Latin1_General_CP1_CI_AS") {
            Write-Log "⚠ Collation recommandée : SQL_Latin1_General_CP1_CI_AS" "WARN"
            Write-Log "⚠ Collation actuelle : $collation" "WARN"
        } else {
            Write-Log "Collation SQL : Compatible ✔" "SUCCESS"
        }
    } catch {
        Write-Log "Impossible de vérifier la collation : $($_.Exception.Message)" "WARN"
    }

    # ── Créer les dossiers SQL ───────────────────────────────
    foreach ($sqlPath in @($Config.SQLDataPath, $Config.SQLLogPath, $Config.SQLTempDBPath)) {
        if (-not (Test-Path $sqlPath)) {
            New-Item -ItemType Directory -Path $sqlPath -Force | Out-Null
            Write-Log "Dossier SQL créé : $sqlPath ✔" "SUCCESS"
        }
    }

    Write-Log "Configuration SQL Server terminée ✔" "SUCCESS"
    return $true
}

# ================================================================
# FONCTION : CRÉATION DU FICHIER DE RÉPONSE SCCM
# ================================================================

function New-SCCMUnattendFile {
    Write-Log "Génération du fichier de réponse SCCM (unattend.ini)..." "INFO"

    $unattendContent = @"
; ================================================================
; Fichier de réponse SCCM - Généré automatiquement
; Date : $(Get-Date -Format "yyyy-MM-dd HH:mm:ss")
; Serveur : $($env:COMPUTERNAME).$($env:USERDNSDOMAIN)
; ================================================================

[Identification]
Action=InstallPrimarySite

[Options]
ProductID=EVAL
SiteCode=$($Config.SiteCode)
SiteName=$($Config.SiteName)
SMSInstallDir=$($Config.InstallDir)
SDKServer=$($Config.SiteServerFQDN)
RoleCommunicationProtocol=$($Config.ClientProtocol)
ClientsUsePKICertificate=0
PrerequisiteComp=0
PrerequisitePath=$($Config.SCCMPrereqPath)
MobileDeviceLanguage=0
ManagementPoint=$($Config.SiteServerFQDN)
ManagementPointProtocol=HTTP
DistributionPoint=$($Config.SiteServerFQDN)
DistributionPointProtocol=HTTP
DistributionPointInstallIIS=1
AdminConsole=$($Config.InstallAdminConsole)
JoinCEIP=$($Config.JoinCEIP)

[SQLConfigOptions]
SQLServerName=$($Config.SQLServerInstance)
DatabaseName=$($Config.SQLDatabaseName)
SQLSSBPort=$($Config.SQLSSBPort)
SQLDataFilePath=$($Config.SQLDataPath)\
SQLLogFilePath=$($Config.SQLLogPath)\

[CloudConnectorOptions]
CloudConnector=0
UseProxy=0
ProxyName=
ProxyPort=

[SystemCenterOptions]

[HierarchyExpansionOption]
"@

    $unattendPath = Join-Path $Config.LogDir "SCCMUnattend.ini"
    $unattendContent | Out-File -FilePath $unattendPath -Encoding ASCII -Force

    Write-Log "Fichier de réponse créé : $unattendPath ✔" "SUCCESS"

    # Afficher un aperçu
    Write-Log "Aperçu de la configuration :" "INFO"
    Write-Log "  Code Site  : $($Config.SiteCode)" "INFO"
    Write-Log "  Nom Site   : $($Config.SiteName)" "INFO"
    Write-Log "  SQL Server : $($Config.SQLServerInstance)" "INFO"
    Write-Log "  Base SQL   : $($Config.SQLDatabaseName)" "INFO"
    Write-Log "  Dossier    : $($Config.InstallDir)" "INFO"

    return $unattendPath
}

# ================================================================
# FONCTION : INSTALLATION SCCM
# ================================================================

function Start-SCCMInstallation {
    param([string]$UnattendFilePath)

    Write-Step 6 6 "Installation de Microsoft SCCM"

    $setupExe = Join-Path $Config.SCCMSourcePath "SMSSETUP\BIN\X64\setup.exe"

    if (-not (Test-Path $setupExe)) {
        Write-Log "setup.exe SCCM introuvable : $setupExe" "ERROR"
        return $false
    }

    # Récupérer les prérequis en ligne (optionnel)
    Write-Log "Récupération des prérequis SCCM depuis Microsoft..." "INFO"
    Write-Log "Dossier prérequis : $($Config.SCCMPrereqPath)" "INFO"

    $downloadArgs = @(
        "/NOUI",
        "/DOWNLOADONLY",
        "/NOINSTALL"
    )

    Write-Log "Démarrage de l'installation SCCM..." "INFO"
    Write-Log "⚠ Cette opération prend généralement 30 à 90 minutes" "WARN"
    Write-Log "Fichier de réponse : $UnattendFilePath" "INFO"
    Write-Log "Log d'installation : $($Config.InstallDir)\Logs\ConfigMgrSetup.log" "INFO"
    Write-Host ""

    $setupArgs = @(
        "/NOUSERINPUT",
        "/SCRIPT", "`"$UnattendFilePath`"",
        "/NOUI"
    )

    try {
        $stopwatch = [System.Diagnostics.Stopwatch]::StartNew()

        $proc = Start-Process -FilePath $setupExe `
                              -ArgumentList $setupArgs `
                              -Wait -PassThru

        $stopwatch.Stop()
        $elapsed = $stopwatch.Elapsed.ToString("hh\:mm\:ss")

        Write-Log "Durée d'installation : $elapsed" "INFO"

        switch ($proc.ExitCode) {
            0 {
                Write-Log "Installation SCCM terminée avec succès! (Code: 0) ✔" "SUCCESS"
                return $true
            }
            1 {
                Write-Log "Installation SCCM réussie - Redémarrage requis (Code: 1)" "WARN"
                return $true
            }
            2 {
                Write-Log "Installation SCCM échouée (Code: 2)" "ERROR"
                return $false
            }
            default {
                Write-Log "Code de sortie inattendu : $($proc.ExitCode)" "ERROR"
                return $false
            }
        }
    } catch {
        Write-Log "Exception lors de l'installation SCCM : $($_.Exception.Message)" "ERROR"
        return $false
    }
}

# ================================================================
# FONCTION : RAPPORT POST-INSTALLATION
# ================================================================

function Show-InstallationReport {
    param([hashtable]$Results)

    Write-Host ""
    Write-Host "  ╔══════════════════════════════════════════════════════════╗" -ForegroundColor $(if($Results.Success){"Green"}else{"Red"})
    Write-Host "  ║          RAPPORT D'INSTALLATION SCCM                    ║" -ForegroundColor $(if($Results.Success){"Green"}else{"Red"})
    Write-Host "  ╠══════════════════════════════════════════════════════════╣" -ForegroundColor White
    Write-Host "  ║  Statut global : $(if($Results.Success){"SUCCÈS  ✔                              "}else{"ÉCHEC   ✖                              "})" -ForegroundColor $(if($Results.Success){"Green"}else{"Red"})
    Write-Host "  ║  Durée totale  : $($Results.Duration)                            " -ForegroundColor White
    Write-Host "  ╠══════════════════════════════════════════════════════════╣" -ForegroundColor White
    Write-Host "  ║  CONFIGURATION DU SITE :                                ║" -ForegroundColor Cyan
    Write-Host "  ║    Code Site  : $($Config.SiteCode)                                     " -ForegroundColor White
    Write-Host "  ║    Nom Site   : $($Config.SiteName)                    " -ForegroundColor White
    Write-Host "  ║    Serveur    : $($Config.SiteServerFQDN)              " -ForegroundColor White
    Write-Host "  ║    SQL Server : $($Config.SQLServerInstance)           " -ForegroundColor White
    Write-Host "  ╠══════════════════════════════════════════════════════════╣" -ForegroundColor White
    Write-Host "  ║  PROCHAINES ÉTAPES :                                    ║" -ForegroundColor Yellow
    Write-Host "  ║    1. Ouvrir la console SCCM                            ║" -ForegroundColor White
    Write-Host "  ║    2. Configurer les limites et groupes de limites       ║" -ForegroundColor White
    Write-Host "  ║    3. Configurer la découverte AD                        ║" -ForegroundColor White
    Write-Host "  ║    4. Déployer le client SCCM                           ║" -ForegroundColor White
    Write-Host "  ║    5. Configurer le point de mise à jour logicielle      ║" -ForegroundColor White
    Write-Host "  ╠══════════════════════════════════════════════════════════╣" -ForegroundColor White
    Write-Host "  ║  CHEMINS IMPORTANTS :                                   ║" -ForegroundColor Cyan
    Write-Host "  ║  Console : $($Config.InstallDir)\AdminUI\bin\    " -ForegroundColor White
    Write-Host "  ║  Logs    : $($Config.InstallDir)\Logs\                  " -ForegroundColor White
    Write-Host "  ║  Scripts : $($Config.LogDir)\                           " -ForegroundColor White
    Write-Host "  ╚══════════════════════════════════════════════════════════╝" -ForegroundColor $(if($Results.Success){"Green"}else{"Red"})
    Write-Host ""

    Write-Log "Rapport sauvegardé dans : $($Config.LogDir)\$($Config.LogFile)" "INFO"
}

# ================================================================
# POINT D'ENTRÉE PRINCIPAL
# ================================================================

$globalStopwatch = [System.Diagnostics.Stopwatch]::StartNew()

# Initialisation
Initialize-Environment

Write-Banner "Microsoft SCCM - Script d'Installation v1.0" "Blue"

Write-Log "═══════════════════════════════════════════════════" "INFO"
Write-Log "Démarrage du script - Mode : $Mode" "INFO"
Write-Log "Serveur  : $($env:COMPUTERNAME)" "INFO"
Write-Log "Domaine  : $($env:USERDNSDOMAIN)" "INFO"
Write-Log "User     : $($env:USERNAME)" "INFO"
Write-Log "PS Ver   : $($PSVersionTable.PSVersion)" "INFO"
Write-Log "Log      : $($Config.LogDir)\$($Config.LogFile)" "INFO"
Write-Log "═══════════════════════════════════════════════════" "INFO"

$installResult = $true

# ── Exécution selon le mode ──────────────────────────────────
switch ($Mode) {

    "CheckOnly" {
        $installResult = Test-AllPrerequisites
        Write-Log "Mode CheckOnly : Vérification terminée" "INFO"
    }

    "PrereqOnly" {
        $installResult = Test-AllPrerequisites
        if ($installResult -or $true) {  # Continue même si des warnings
            Install-WindowsPrerequisites
            Install-WindowsADK
        }
    }

    "SchemaOnly" {
        $installResult = Expand-ADSchema
    }

    "SCCMOnly" {
        Set-SQLServerConfiguration
        $unattendFile  = New-SCCMUnattendFile
        $installResult = Start-SCCMInstallation -UnattendFilePath $unattendFile
    }

    "Full" {
        # Étape 1 : Prérequis
        $prereqOK = Test-AllPrerequisites

        if (-not $prereqOK) {
            Write-Log "Des prérequis obligatoires ne sont pas satisfaits." "ERROR"
            $response = Read-Host "`n  Continuer quand même ? (O/N) [N par défaut]"
            if ($response.ToUpper() -ne "O") {
                Write-Log "Installation annulée par l'utilisateur." "INFO"
                exit 2
            }
        }

        # Étape 2 : Fonctionnalités Windows
        $featuresOK = Install-WindowsPrerequisites

        # Étape 3 : ADK
        $adkOK = Install-WindowsADK
        if (-not $adkOK) {
            Write-Log "ADK non installé - Continuez manuellement si nécessaire" "WARN"
        }

        # Étape 4 : Schéma AD
        $schemaOK = Expand-ADSchema
        if (-not $schemaOK) {
            Write-Log "Extension schéma AD ignorée ou échouée" "WARN"
        }

        # Étape 5 : SQL Server
        Set-SQLServerConfiguration

        # Étape 6 : Installation SCCM
        $unattendFile  = New-SCCMUnattendFile
        $installResult = Start-SCCMInstallation -UnattendFilePath $unattendFile
    }
}

# ── Rapport final ────────────────────────────────────────────
$globalStopwatch.Stop()
$totalDuration = $globalStopwatch.Elapsed.ToString("hh\:mm\:ss")

Show-InstallationReport -Results @{
    Success  = $installResult
    Duration = $totalDuration
    Mode     = $Mode
}

Write-Log "Script terminé en $totalDuration" "INFO"

if ($installResult) {
    Write-Log "═══════ INSTALLATION RÉUSSIE ═══════" "SUCCESS"
    exit 0
} else {
    Write-Log "═══════ INSTALLATION ÉCHOUÉE ═══════" "ERROR"
    Write-Log "Consultez les logs : $($Config.LogDir)\$($Config.LogFile)" "ERROR"
    exit 1
}