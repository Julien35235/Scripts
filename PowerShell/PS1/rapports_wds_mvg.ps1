# ==============================================================================
# Rapport Déploiement MDT - Version Spéciale Espace de Noms (unattend:) - FIXÉ
# ==============================================================================

$Date = Get-Date -Format "yyyy-MM-dd_HH-mm"
$ComputerName = $env:COMPUTERNAME
$ReportPath = "$env:USERPROFILE\Desktop\Rapport_MDT_Complet_$Date.html"

# --- 1. Collecte des Données Système ---
$OS = Get-CimInstance Win32_OperatingSystem
$CPU = Get-CimInstance Win32_Processor
$RAM = Get-CimInstance Win32_PhysicalMemory
$Disks = Get-CimInstance Win32_LogicalDisk -Filter "DriveType=3"
$WDSService = Get-Service -Name "WDSServer" -ErrorAction SilentlyContinue

$CPUUsage = [math]::Round((Get-Counter '\Processor(_Total)\% Processor Time').CounterSamples.CookedValue, 2)
$RAMUsage = [math]::Round((($OS.TotalVisibleMemorySize - $OS.FreePhysicalMemory) / $OS.TotalVisibleMemorySize) * 100, 2)

$SharePath = "D:\WDS\DeploymentShare"

# --- 2. Initialisation des Listes ---
$MDT_OS_List = @()
$MDT_Tasks_List = @()
$MDT_Apps_List = @()
$MDT_Drivers_List = @()

# --- 3. Fonction d'Extraction Spéciale "unattend:" (Insensible au préfixe) ---
function Extract-MdtNamespaceItems {
    param (
        [string]$FilePath,
        [string]$ItemTag
    )
    $Results = @()
    if (-not (Test-Path $FilePath)) { return $Results }
    
    $RawContent = Get-Content -Path $FilePath -Raw -ErrorAction SilentlyContinue
    if (-not $RawContent) { return $Results }

    # Ce pattern magique capture <TaskSequence> ET <unattend:TaskSequence>
    $Pattern = "(?i)<(?:[a-z0-9]+:)?$ItemTag[^>]*>([\s\S]*?)</(?:[a-z0-9]+:)?$ItemTag>"
    $Matches = [regex]::Matches($RawContent, $Pattern)

    foreach ($Match in $Matches) {
        $Inner = $Match.Groups[1].Value
        $ItemObj = @{}
        
        # Capture les sous-propriétés en ignorant également leur préfixe (ex: <unattend:Name>)
        $PropMatches = [regex]::Matches($Inner, "(?i)<(?:[a-z0-9]+:)?([a-z0-9_]+)[^>]*>([^<]*)</(?:[a-z0-9]+:)?\1>")
        foreach ($Prop in $PropMatches) {
            $Key = $Prop.Groups[1].Value
            $Val = $Prop.Groups[2].Value.Trim()
            if (-not $ItemObj.ContainsKey($Key)) {
                $ItemObj[$Key] = $Val
            }
        }
        if ($ItemObj.Count -gt 0) {
            $Results += [PSCustomObject]$ItemObj
        }
    }
    return $Results
}

# --- 4. Chargement Forcé des données ---
$MDT_OS_List = Extract-MdtNamespaceItems -FilePath "$SharePath\Control\OperatingSystems.xml" -ItemTag "OperatingSystem"
$MDT_Tasks_List = Extract-MdtNamespaceItems -FilePath "$SharePath\Control\TaskSequences.xml" -ItemTag "TaskSequence"
$MDT_Apps_List = Extract-MdtNamespaceItems -FilePath "$SharePath\Control\Applications.xml" -ItemTag "Application"
$MDT_Drivers_List = Extract-MdtNamespaceItems -FilePath "$SharePath\Control\Drivers.xml" -ItemTag "Driver"

# Configuration des statuts
$DisplaySharePath = if (Test-Path $SharePath) { $SharePath } else { "D:\WDS\DeploymentShare (Introuvable)" }
$WdsStatusBadge = if ($WDSService -and $WDSService.Status -eq "Running") { "<span class='badge badge-active'>En Cours (Actif)</span>" } else { "<span class='badge badge-inactive'>Arrêté</span>" }

# --- 5. Génération de l'HTML ---
$HTML = @"
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <title>Rapport d'Infrastructure Déploiement - $ComputerName</title>
    <style>
        body { font-family: 'Segoe UI', Tahoma, sans-serif; background-color: #f0f4f8; margin: 0; padding: 30px; color: #1e293b; }
        .header { background: linear-gradient(135deg, #0f172a 0%, #1e3a8a 100%); color: white; padding: 30px; border-radius: 8px; margin-bottom: 30px; }
        .header h1 { margin: 0; font-size: 2rem; }
        .header p { margin: 8px 0 0 0; color: #93c5fd; }
        h2 { color: #1e3a8a; font-size: 1.4rem; margin-top: 40px; border-bottom: 2px solid #cbd5e1; padding-bottom: 8px; }
        .card { background: white; padding: 20px; border-radius: 8px; box-shadow: 0 1px 3px rgba(0,0,0,0.05); margin-bottom: 25px; }
        .metrics-grid { display: grid; grid-template-columns: repeat(auto-fit, minmax(220px, 1fr)); gap: 20px; }
        .metric { background: #f8fafc; padding: 15px; border-radius: 6px; border-left: 4px solid #2563eb; }
        .metric-lbl { font-size: 0.8rem; text-transform: uppercase; color: #64748b; font-weight: 700; }
        .metric-val { font-size: 1.25rem; font-weight: 700; color: #0f172a; margin-top: 5px; }
        table { width: 100%; border-collapse: collapse; background: white; border-radius: 6px; overflow: hidden; margin-top: 15px; }
        th { background-color: #334155; color: white; padding: 12px 15px; text-align: left; font-size: 0.9rem; }
        td { padding: 12px 15px; border-bottom: 1px solid #e2e8f0; font-size: 0.9rem; color: #334155; }
        tr:hover { background-color: #f8fafc; }
        .badge { padding: 4px 8px; border-radius: 4px; font-size: 0.8rem; font-weight: bold; }
        .badge-active { background-color: #d1fae5; color: #065f46; }
        .badge-inactive { background-color: #fee2e2; color: #991b1b; }
        .badge-driver { background-color: #e0f2fe; color: #0369a1; }
        .code-block { font-family: Consolas, monospace; background-color: #f1f5f9; padding: 2px 5px; border-radius: 4px; font-size: 0.85rem; display: inline-block; }
    </style>
</head>
<body>

<div class="header">
    <h1>Rapport d'Infrastructure Déploiement : $ComputerName</h1>
    <p>Serveur Windows Server 2022 | Audit Global MDT Fixé (Espace de Noms inclus)</p>
</div>

<h2>1. Résumé & Performances Système</h2>
<div class="card metrics-grid">
    <div class="metric"><div class="metric-lbl">Système d'exploitation</div><div class="metric-val">$($OS.Caption)</div></div>
    <div class="metric"><div class="metric-lbl">Utilisation CPU / RAM</div><div class="metric-val">$CPUUsage % / $RAMUsage %</div></div>
    <div class="metric"><div class="metric-lbl">Total Séquences de Tâches</div><div class="metric-val">$($MDT_Tasks_List.Count) trouvées</div></div>
    <div class="metric"><div class="metric-lbl">Date de Génération</div><div class="metric-val">$(Get-Date -Format "dd/MM/yyyy HH:mm")</div></div>
</div>

<h2>2. Statut du Rôle Réseau WDS</h2>
<div class="card">
    <table>
        <tr>
            <th>Composant Service</th>
            <th>Nom Windows</th>
            <th>Statut Opérationnel</th>
            <th>Dossier Racine MDT</th>
        </tr>
        <tr>
            <td><b>WDS Server Core (PXE)</b></td>
            <td><span class="code-block">WDSServer</span></td>
            <td>$WdsStatusBadge</td>
            <td><span class="code-block">$DisplaySharePath</span></td>
        </tr>
    </table>
</div>

<h2>3. Systèmes d'Exploitation Importés (Fichiers ISO)</h2>
<div class="card">
    <table>
        <thead>
            <tr>
                <th>Nom de l'OS dans MDT</th>
                <th>Description</th>
                <th>Plateforme</th>
                <th>Build</th>
            </tr>
        </thead>
        <tbody>
"@

if ($MDT_OS_List.Count -gt 0) {
    foreach ($O in $MDT_OS_List) {
        $HTML += "<tr><td><b>$($O.Name)</b></td><td>$($O.Description)</td><td><span class='badge badge-driver'>$($O.Platform)</span></td><td>$($O.Build)</td></tr>"
    }
} else {
    $HTML += "<tr><td colspan='4'>Aucun OS importé détecté.</td></tr>"
}

$HTML += @"
        </tbody>
    </table>
</div>

<h2>4. Séquences de Tâches (Task Sequences)</h2>
<div class="card">
    <table>
        <thead>
            <tr>
                <th style="width: 25%;">ID Séquence</th>
                <th style="width: 50%;">Nom de la Séquence</th>
                <th style="width: 25%;">État MDT</th>
            </tr>
        </thead>
        <tbody>
"@

if ($MDT_Tasks_List.Count -gt 0) {
    foreach ($T in $MDT_Tasks_List) {
        $Status = if ($T.Enabled -match "False") { "<span class='badge badge-inactive'>Désactivée</span>" } else { "<span class='badge badge-active'>Active</span>" }
        $HTML += "<tr><td><span class='code-block'>$($T.ID)</span></td><td><b>$($T.Name)</b></td><td>$Status</td></tr>"
    }
} else {
    $HTML += "<tr><td colspan='3'>Aucune séquence trouvée.</td></tr>"
}

$HTML += @"
        </tbody>
    </table>
</div>

<h2>5. Catalogue d'Applications (Installations Silencieuses)</h2>
<div class="card">
    <table>
        <thead>
            <tr>
                <th>Nom de l'Application</th>
                <th>Éditeur / Version</th>
                <th>Ligne de commande d'installation silencieuse</th>
            </tr>
        </thead>
        <tbody>
"@

if ($MDT_Apps_List.Count -gt 0) {
    foreach ($A in $MDT_Apps_List) {
        $HTML += "<tr><td><b>$($A.Name)</b></td><td>$($A.Publisher) ($($A.Version))</td><td><span class='code-block'>$($A.CommandLine)</span></td></tr>"
    }
} else {
    $HTML += "<tr><td colspan='3'>Aucune application configurée.</td></tr>"
}

$HTML += @"
        </tbody>
    </table>
</div>

<h2>6. Pilotes Injectés (Out-of-Box Drivers)</h2>
<div class="card">
    <table>
        <thead>
            <tr>
                <th>Nom du Pilote / Fichier INF</th>
                <th>Classe</th>
                <th>Version du Pilote</th>
                <th>Plateforme</th>
            </tr>
        </thead>
        <tbody>
"@

if ($MDT_Drivers_List.Count -gt 0) {
    $Counter = 0
    foreach ($D in $MDT_Drivers_List) {
        if ($Counter -lt 20) {
            $HTML += "<tr><td><b>$($D.Name)</b></td><td><span class='badge badge-driver'>$($D.Class)</span></td><td>$($D.Version)</td><td>$($D.Platform)</td></tr>"
            $Counter++
        }
    }
    if ($MDT_Drivers_List.Count -gt 20) {
        $Reste = $MDT_Drivers_List.Count - 20
        $HTML += "<tr><td colspan='4' style='text-align:center; color:#64748b; font-style:italic;'>... Et $Reste autres pilotes stockés.</td></tr>"
    }
} else {
    $HTML += "<tr><td colspan='4'>Aucun pilote injecté dans la console MDT.</td></tr>"
}

# --- CORRECTION ICI : Fermeture de la balise HTML pour la section 6 ---
$HTML += @"
        </tbody>
    </table>
</div>

<h2>7. Stockage des Volumes Disques</h2>
<div class="card">
    <table>
        <thead>
            <tr>
                <th>Lecteur</th>
                <th>Taille Totale</th>
                <th>Espace Libre</th>
                <th>Pourcentage Libre</th>
            </tr>
        </thead>
        <tbody>
"@

foreach ($Disk in $Disks) {
    $TotalGB = [math]::Round($Disk.Size / 1GB, 2)
    $FreeGB = [math]::Round($Disk.FreeSpace / 1GB, 2)
    $PercentFree = [math]::Round(($FreeGB / $TotalGB) * 100, 1)
    $HTML += "<tr><td><b>$($Disk.DeviceID)</b></td><td>$TotalGB Go</td><td>$FreeGB Go</td><td>$PercentFree %</td></tr>"
}

$HTML += @"
        </tbody>
    </table>
</div>

</body>
</html>
"@

# Exportation propre
$HTML | Out-File -Encoding UTF8 $ReportPath
Write-Host "Le rapport a été généré sur votre bureau : $ReportPath" -ForegroundColor Green