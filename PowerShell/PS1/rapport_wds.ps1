# ==============================================================================
# Rapport Système Windows Server 2022 (WDS / MDT Edition)
# ==============================================================================

$Date = Get-Date -Format "yyyy-MM-dd_HH-mm"
$ComputerName = $env:COMPUTERNAME
$ReportPath = "$env:USERPROFILE\Desktop\Rapport_Serveur_Deploiement_$Date.html"

# 1. Collecte des Informations Système de Base
$OS = Get-CimInstance Win32_OperatingSystem
$CPU = Get-CimInstance Win32_Processor
$RAM = Get-CimInstance Win32_PhysicalMemory
$Disks = Get-CimInstance Win32_LogicalDisk -Filter "DriveType=3"
$Network = Get-CimInstance Win32_NetworkAdapterConfiguration | Where-Object {$_.IPEnabled -eq $true}

# 2. Calcul des Performances et RAM
$TotalRAM = [math]::Round(($RAM.Capacity | Measure-Object -Sum).Sum / 1GB, 2)
$CPUUsage = [math]::Round((Get-Counter '\Processor(_Total)\% Processor Time').CounterSamples.CookedValue, 2)
$RAMUsage = [math]::Round((($OS.TotalVisibleMemorySize - $OS.FreePhysicalMemory) / $OS.TotalVisibleMemorySize) * 100, 2)

# 3. Vérification Spécifique WDS & MDT
$WDSService = Get-Service -Name "WDSServer" -ErrorAction SilentlyContinue

# Détection des Deployment Shares MDT via le registre
$MDTShares = Get-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Deployment 4" -ErrorAction SilentlyContinue | 
             Get-Member -MemberType NoteProperty | 
             Where-Object {$_.Name -like "DeploymentShare*"} | 
             ForEach-Object { (Get-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Deployment 4").$($_.Name) }

# 4. Liste complète et propre des applications (64-bit ET 32-bit)
$RegPaths = @(
    "HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall\*",
    "HKLM:\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall\*"
)
$InstalledApps = Get-ItemProperty $RegPaths -ErrorAction SilentlyContinue |
                 Where-Object { $_.DisplayName -and $_.SystemComponent -ne 1 } |
                 Select-Object DisplayName, DisplayVersion, Publisher |
                 Sort-Object DisplayName -Unique

# ==============================================================================
# Génération du HTML (Nouveau Design Moderne & Responsive)
# ==============================================================================

$HTML = @"
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <title>Rapport Infrastructure Déploiement - $ComputerName</title>
    <style>
        body { font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; background-color: #f5f7fa; margin: 0; padding: 30px; color: #333; }
        h1 { color: #2c3e50; font-weight: 600; border-bottom: 3px solid #3498db; padding-bottom: 10px; margin-bottom: 30px; }
        h2 { color: #2c3e50; font-size: 1.4rem; margin-top: 40px; margin-bottom: 15px; display: flex; align-items: center; }
        
        .card { background: white; padding: 20px; border-radius: 8px; box-shadow: 0 4px 6px rgba(0,0,0,0.05); margin-bottom: 25px; }
        .grid { display: grid; grid-template-columns: repeat(auto-fit, minmax(220px, 1fr)); gap: 20px; }
        .metric { background: #f8f9fa; padding: 15px; border-radius: 6px; border-left: 4px solid #3498db; }
        .metric-title { font-size: 0.85rem; text-transform: uppercase; color: #7f8c8d; font-weight: bold; }
        .metric-value { font-size: 1.2rem; font-weight: bold; color: #2c3e50; margin-top: 5px; }
        
        table { width: 100%; border-collapse: collapse; background: white; border-radius: 8px; overflow: hidden; box-shadow: 0 4px 6px rgba(0,0,0,0.05); margin-bottom: 30px; }
        th { background-color: #34495e; color: white; padding: 12px 15px; text-align: left; font-weight: 500; font-size: 0.9rem; }
        td { padding: 12px 15px; border-bottom: 1px solid #eeeeee; font-size: 0.9rem; color: #555; }
        tr:hover { background-color: #f9fbfd; }
        
        .badge { padding: 4px 8px; border-radius: 4px; font-size: 0.8rem; font-weight: bold; display: inline-block; }
        .badge-running { background-color: #2ecc71; color: white; }
        .badge-stopped { background-color: #e74c3c; color: white; }
        .badge-missing { background-color: #f1c40f; color: #333; }
    </style>
</head>
<body>

<h1>Rapport Serveur de Déploiement : $ComputerName</h1>

<div class="card">
    <div class="grid">
        <div class="metric">
            <div class="metric-title">Système d'exploitation</div>
            <div class="metric-value">$($OS.Caption)</div>
        </div>
        <div class="metric">
            <div class="metric-title">Généré le</div>
            <div class="metric-value">$(Get-Date -Format "dd/MM/yyyy HH:mm")</div>
        </div>
        <div class="metric">
            <div class="metric-title">Dernier Démarrage</div>
            <div class="metric-value">$([Management.ManagementDateTimeConverter]::ToDateTime($OS.LastBootUpTime).ToString("dd/MM/yyyy HH:mm"))</div>
        </div>
        <div class="metric">
            <div class="metric-title">Utilisation CPU / RAM</div>
            <div class="metric-value">$CPUUsage % / $RAMUsage %</div>
        </div>
    </div>
</div>

<h2>Rôles de Déploiement (WDS & MDT)</h2>
<div class="card">
    <h3>Statut des Services</h3>
    <table>
        <tr>
            <th>Rôle / Service</th>
            <th>Nom Windows</th>
            <th>Statut</th>
        </tr>
        <tr>
            <td><b>WDS (Windows Deployment Services)</b></td>
            <td>WDSServer</td>
            <td>
                $(if ($WDSService) {
                    if ($WDSService.Status -eq "Running") { "<span class='badge badge-running'>En cours d'exécution</span>" }
                    else { "<span class='badge badge-stopped'>Arrêté</span>" }
                } else { "<span class='badge badge-missing'>Non Installé</span>" })
            </td>
        </tr>
    </table>

    <h3>Partages de déploiement MDT (Deployment Shares)</h3>
    <table>
        <tr>
            <th>Chemin du Partage</th>
            <th>Espace Disque Libre</th>
        </tr>
"@

if ($MDTShares) {
    foreach ($Share in $MDTShares) {
        if (Test-Path $Share) {
            $DriveLetter = (Get-Item $Share).Drive.Name + ":"
            $DiskTarget = Get-CimInstance Win32_LogicalDisk -Filter "DeviceID='$DriveLetter'"
            $FreeGB = [math]::Round($DiskTarget.FreeSpace / 1GB, 2)
            $HTML += "<tr><td>$Share</td><td>$FreeGB GB libres sur le lecteur $DriveLetter</td></tr>"
        } else {
            $HTML += "<tr><td>$Share</td><td><span class='badge badge-stopped'>Chemin introuvable</span></td></tr>"
        }
    }
} else {
    $HTML += "<tr><td colspan='2'>Aucun Deployment Share MDT détecté de manière standard dans le registre.</td></tr>"
}

$HTML += @"
    </table>
</div>

<h2>Ressources & Performances</h2>
<table>
    <tr>
        <th>Composant</th>
        <th>Détails</th>
        <th>Utilisation Actuelle</th>
    </tr>
    <tr>
        <td><b>Processeur (CPU)</b></td>
        <td>$($CPU.Name) ($($CPU.NumberOfCores) Coeurs / $($CPU.NumberOfLogicalProcessors) Threads)</td>
        <td><b>$CPUUsage %</b></td>
    </tr>
    <tr>
        <td><b>Mémoire (RAM)</b></td>
        <td>Total : $TotalRAM GB</td>
        <td><b>$RAMUsage %</b> (Inclus le cache WDS)</td>
    </tr>
</table>

<h2>Espace Stockage Disques</h2>
<table>
    <tr>
        <th>Lecteur</th>
        <th>Taille Totale</th>
        <th>Espace Libre</th>
        <th>% Libre</th>
    </tr>
"@

foreach ($Disk in $Disks) {
    $TotalGB = [math]::Round($Disk.Size / 1GB, 2)
    $FreeGB = [math]::Round($Disk.FreeSpace / 1GB, 2)
    $PercentFree = [math]::Round(($FreeGB / $TotalGB) * 100, 1)
    $HTML += @"
    <tr>
        <td><b>$($Disk.DeviceID)</b></td>
        <td>$TotalGB GB</td>
        <td>$FreeGB GB</td>
        <td>$PercentFree %</td>
    </tr>
"@
}

$HTML += @"
</table>

<h2>Configuration Réseau</h2>
<table>
    <tr>
        <th>Interface</th>
        <th>Adresse IP</th>
        <th>Adresse MAC</th>
    </tr>
"@

foreach ($Net in $Network) {
    $HTML += @"
    <tr>
        <td>$($Net.Description)</td>
        <td>$($Net.IPAddress[0])</td>
        <td>$($Net.MACAddress)</td>
    </tr>
"@
}

$HTML += @"
</table>

<h2>Applications et Composants MDT/WDS Installés</h2>
<table>
    <tr>
        <th>Nom du programme</th>
        <th>Version</th>
        <th>Éditeur</th>
    </tr>
"@

foreach ($App in $InstalledApps) {
    $HTML += @"
    <tr>
        <td><b>$($App.DisplayName)</b></td>
        <td>$($App.DisplayVersion)</td>
        <td>$($App.Publisher)</td>
    </tr>
"@
}

$HTML += @"
</table>

</body>
</html>
"@

# Exportation du fichier au format UTF8 propre
$HTML | Out-File -Encoding UTF8 $ReportPath

Write-Host "Le rapport spécialisé MDT/WDS a été généré avec succès ici : $ReportPath" -ForegroundColor Green