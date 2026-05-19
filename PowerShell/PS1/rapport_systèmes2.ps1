# ==========================================
# Rapport Système HTML - PowerShell
# ==========================================

$Date = Get-Date -Format "yyyy-MM-dd_HH-mm"
$ComputerName = $env:COMPUTERNAME
$ReportPath = "$env:USERPROFILE\Desktop\Rapport_Systeme_$Date.html"

# Informations système
$OS = Get-CimInstance Win32_OperatingSystem
$CPU = Get-CimInstance Win32_Processor
$RAM = Get-CimInstance Win32_PhysicalMemory
$Disks = Get-CimInstance Win32_LogicalDisk -Filter "DriveType=3"
$Network = Get-CimInstance Win32_NetworkAdapterConfiguration | Where-Object {$_.IPEnabled -eq $true}
$StoppedServices = Get-Service | Where-Object {$_.Status -eq "Stopped"}
$InstalledApps = Get-ItemProperty HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall\* |
                  Select-Object DisplayName, DisplayVersion, Publisher

# Calcul RAM
$TotalRAM = [math]::Round(($RAM.Capacity | Measure-Object -Sum).Sum / 1GB, 2)

# Utilisation actuelle
$CPUUsage = (Get-Counter '\Processor(_Total)\% Processor Time').CounterSamples.CookedValue
$RAMUsage = [math]::Round((($OS.TotalVisibleMemorySize - $OS.FreePhysicalMemory) / $OS.TotalVisibleMemorySize) * 100,2)

# Début HTML
$HTML = @"
<html>
<head>
    <title>Rapport Système - $ComputerName</title>
    <style>
        body {
            font-family: Arial;
            background-color: #f4f4f4;
            margin: 20px;
        }

        h1 {
            color: #2c3e50;
        }

        h2 {
            background-color: #34495e;
            color: white;
            padding: 5px;
        }

        table {
            width: 100%;
            border-collapse: collapse;
            margin-bottom: 20px;
            background: white;
        }

        th, td {
            border: 1px solid #ccc;
            padding: 8px;
            text-align: left;
        }

        th {
            background-color: #2980b9;
            color: white;
        }

        tr:nth-child(even) {
            background-color: #f2f2f2;
        }

        .info {
            background: white;
            padding: 10px;
            margin-bottom: 20px;
        }
    </style>
</head>
<body>

<h1>Rapport Système - $ComputerName</h1>

<div class='info'>
<b>Date :</b> $(Get-Date)<br>
<b>Système :</b> $($OS.Caption)<br>
<b>Version :</b> $($OS.Version)<br>
<b>Architecture :</b> $($OS.OSArchitecture)<br>
<b>Uptime :</b> $([Management.ManagementDateTimeConverter]::ToDateTime($OS.LastBootUpTime))
</div>

<h2>Performance</h2>

<table>
<tr>
    <th>CPU Utilisation</th>
    <th>RAM Utilisation</th>
    <th>RAM Totale</th>
</tr>
<tr>
    <td>$([math]::Round($CPUUsage,2)) %</td>
    <td>$RAMUsage %</td>
    <td>$TotalRAM GB</td>
</tr>
</table>

<h2>Processeur</h2>

<table>
<tr>
    <th>Nom</th>
    <th>Cœurs</th>
    <th>Threads</th>
</tr>
<tr>
    <td>$($CPU.Name)</td>
    <td>$($CPU.NumberOfCores)</td>
    <td>$($CPU.NumberOfLogicalProcessors)</td>
</tr>
</table>

<h2>Disques</h2>

<table>
<tr>
    <th>Lecteur</th>
    <th>Taille Totale (GB)</th>
    <th>Espace Libre (GB)</th>
</tr>
"@

foreach ($Disk in $Disks) {
    $HTML += @"
<tr>
    <td>$($Disk.DeviceID)</td>
    <td>$([math]::Round($Disk.Size / 1GB,2))</td>
    <td>$([math]::Round($Disk.FreeSpace / 1GB,2))</td>
</tr>
"@
}

$HTML += @"
</table>

<h2>Réseau</h2>

<table>
<tr>
    <th>Description</th>
    <th>Adresse IP</th>
    <th>MAC</th>
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

<h2>Services Arrêtés</h2>

<table>
<tr>
    <th>Nom</th>
    <th>DisplayName</th>
</tr>
"@

foreach ($Service in $StoppedServices) {
    $HTML += @"
<tr>
    <td>$($Service.Name)</td>
    <td>$($Service.DisplayName)</td>
</tr>
"@
}

$HTML += @"
</table>

<h2>Programmes Installés</h2>

<table>
<tr>
    <th>Nom</th>
    <th>Version</th>
    <th>Éditeur</th>
</tr>
"@

foreach ($App in $InstalledApps | Sort-Object DisplayName) {
    if ($App.DisplayName) {
        $HTML += @"
<tr>
    <td>$($App.DisplayName)</td>
    <td>$($App.DisplayVersion)</td>
    <td>$($App.Publisher)</td>
</tr>
"@
    }
}

$HTML += @"
</table>

</body>
</html>
"@

# Export
$HTML | Out-File -Encoding UTF8 $ReportPath

Write-Host "Rapport généré : $ReportPath"