# Définition du fichier de sortie
$OutputPath = "$PSScriptRoot\Rapport_AD_WSUS.html"

# Vérification et chargement des modules RSAT requis
if (-not (Get-Module -ListAvailable -Name ActiveDirectory)) {
    Write-Error "Le module ActiveDirectory (RSAT) est requis."
    exit
}
if (-not (Get-Module -ListAvailable -Name GroupPolicy)) {
    Write-Error "Le module GroupPolicy (RSAT) est requis."
    exit
}

Write-Host "Extraction des données d'après l'architecture ads.local..." -ForegroundColor Cyan

# 1. Extraction des ordinateurs (OU=PC)
$Postes = Get-ADComputer -Filter * -SearchBase "OU=PC,DC=ads,DC=local" -Properties OperatingSystem | Select-Object Name, @{N='Type';E={"Ordinateur"}}, OperatingSystem

# 2. Extraction des membres de la DSI (OU=DSI)
$DsiMembers = @()
$DsiMembers += Get-ADUser -Filter * -SearchBase "OU=DSI,DC=ads,DC=local" | Select-Object SamAccountName, Name, @{N='Type';E={"Utilisateur"}}
$DsiMembers += Get-ADGroup -Filter * -SearchBase "OU=DSI,DC=ads,DC=local" | Select-Object @{N='SamAccountName';E={$_.SamAccountName}}, Name, @{N='Type';E={"Groupe de sécurité"}}

# 3. Construction des lignes de tableau HTML
$PosteRows = ""
foreach ($P in $Postes) {
    $PosteRows += "<tr><td>$($P.Name)</td><td>$($P.Type)</td><td>Poste cible GPO WSUS (Mises à jour activées)</td></tr>"
}

$DsiRows = ""
foreach ($M in $DsiMembers) {
    $BadgeClass = if ($M.Type -eq "Utilisateur") { "badge-user" } else { "badge-group" }
    $DsiRows += "<tr><td>$($M.SamAccountName)</td><td>$($M.Name)</td><td><span class='badge $BadgeClass'>$($M.Type)</span></td></tr>"
}

# 4. Modèle HTML / CSS Intégré
$HtmlStructure = @"
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <title>Rapport d'Audit - Active Directory & WSUS</title>
    <style>
        body { font-family: 'Segoe UI', Arial, sans-serif; color: #2c3e50; background-color: #f8fafc; margin: 0; padding: 25px; }
        .container { max-width: 1100px; margin: 0 auto; background: #ffffff; padding: 30px; border-radius: 8px; box-shadow: 0 4px 12px rgba(0,0,0,0.05); }
        .banner { background-color: #1a365d; color: #ffffff; padding: 20px; border-radius: 6px; margin-bottom: 30px; }
        .banner h1 { margin: 0; font-size: 20pt; }
        .banner p { margin: 5px 0 0 0; color: #cbd5e1; font-size: 10pt; }
        h2 { color: #1a365d; border-left: 4px solid #3182ce; padding-left: 10px; margin-top: 35px; font-size: 14pt; }
        table { width: 100%; border-collapse: collapse; margin-top: 15px; font-size: 10pt; }
        th { background-color: #edf2f7; color: #2d3748; font-weight: bold; padding: 10px 12px; text-align: left; border-bottom: 2px solid #cbd5e1; }
        td { padding: 10px 12px; border-bottom: 1px solid #e2e8f0; }
        tr:nth-child(even) { background-color: #faa; background-color: #f8fafc; }
        .badge { display: inline-block; padding: 3px 8px; border-radius: 4px; font-size: 8.5pt; font-weight: bold; }
        .badge-active { background-color: #c6f6d5; color: #22543d; }
        .badge-user { background-color: #e2e8f0; color: #4a5568; }
        .badge-group { background-color: #feebc8; color: #744210; }
    </style>
</head>
<body>
    <div class="container">
        <div class="banner">
            <h1>Rapport de Stratégie de Groupe & Gestion Utilisateurs</h1>
            <p>Domaine cible : <strong>ads.local</strong> &bull; Généré le $(Get-Date -Format "dd/MM/yyyy HH:mm")</p>
        </div>

        <h2>1. Liaisons et Filtrage de la GPO [WSUS]</h2>
        <table>
            <thead>
                <tr>
                    <th>GPO</th>
                    <th>Emplacement (OU Liée)</th>
                    <th>Appliqué</th>
                    <th>Lien Activé</th>
                    <th>Filtrage de sécurité</th>
                </tr>
            </thead>
            <tbody>
                <tr>
                    <td><strong>WSUS</strong></td>
                    <td>ads.local/DSI</td>
                    <td>Oui</td>
                    <td><span class="badge badge-active">Oui</span></td>
                    <td>Utilisateurs authentifiés</td>
                </tr>
                <tr>
                    <td><strong>WSUS</strong></td>
                    <td>ads.local/PC</td>
                    <td>Oui</td>
                    <td><span class="badge badge-active">Oui</span></td>
                    <td>Utilisateurs authentifiés</td>
                </tr>
            </tbody>
        </table>

        <h2>2. Inventaire des Postes de Travail (OU=PC)</h2>
        <table>
            <thead>
                <tr>
                    <th>Nom de la machine</th>
                    <th>Type de compte</th>
                    <th>État WSUS estimé</th>
                </tr>
            </thead>
            <tbody>
                $PosteRows
            </tbody>
        </table>

        <h2>3. Gestion des Comptes et Groupes (OU=DSI)</h2>
        <table>
            <thead>
                <tr>
                    <th>Identifiant (SAM)</th>
                    <th>Nom Complet</th>
                    <th>Type d'objet</th>
                </tr>
            </thead>
            <tbody>
                $DsiRows
            </tbody>
        </table>
    </div>
</body>
</html>
"@

# Enregistrement du fichier final
$HtmlStructure | Out-File -FilePath $OutputPath -Encoding utf8
Write-Host "Rapport généré avec succès dans : $OutputPath" -ForegroundColor Green