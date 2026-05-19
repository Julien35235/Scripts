# ============================================
# Rapport Gestionnaire de Tâches en HTML
# ============================================

# Date du rapport
$date = Get-Date -Format "dd/MM/yyyy HH:mm:ss"

# Nom du fichier HTML
$rapport = "$env:USERPROFILE\Desktop\Rapport_Systeme.html"

# Informations système
$os = Get-CimInstance Win32_OperatingSystem
$cpu = Get-CimInstance Win32_Processor
$ramTotal = [math]::Round($os.TotalVisibleMemorySize / 1MB, 2)
$ramLibre = [math]::Round($os.FreePhysicalMemory / 1MB, 2)

# Top processus par CPU
$processus = Get-Process |
    Sort-Object CPU -Descending |
    Select-Object -First 15 Name, Id,
    @{Name="CPU(s)";Expression={[math]::Round($_.CPU,2)}},
    @{Name="Mémoire(MB)";Expression={[math]::Round($_.WorkingSet / 1MB,2)}}

# Services actifs
$services = Get-Service |
    Where-Object {$_.Status -eq "Running"} |
    Select-Object -First 20 Name, DisplayName, Status

# Début HTML
$html = @"
<html>
<head>
    <title>Rapport Système</title>
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
            background-color: #3498db;
            color: white;
            padding: 8px;
        }

        table {
            border-collapse: collapse;
            width: 100%;
            margin-bottom: 20px;
            background-color: white;
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
            background-color: white;
            padding: 10px;
            border: 1px solid #ccc;
        }
    </style>
</head>
<body>

<h1>Rapport du système</h1>
<p>Généré le : $date</p>

<h2>Informations Système</h2>

<div class="info">
    <p><strong>Système :</strong> $($os.Caption)</p>
    <p><strong>Processeur :</strong> $($cpu.Name)</p>
    <p><strong>RAM Totale :</strong> $ramTotal Go</p>
    <p><strong>RAM Libre :</strong> $ramLibre Go</p>
</div>

<h2>Top Processus</h2>
$($processus | ConvertTo-Html -Fragment)

<h2>Services Actifs</h2>
$($services | ConvertTo-Html -Fragment)

</body>
</html>
"@

# Export du fichier HTML
$html | Out-File -Encoding UTF8 $rapport

# Ouvrir automatiquement le rapport
Start-Process $rapport

Write-Host "Rapport généré : $rapport"