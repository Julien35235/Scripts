# Récupération du nom depuis l'argument
$nom = $args[0]

# Si aucun argument n'est fourni, demander à l'utilisateur
if (-not $nom) {
    $nom = Read-Host "Veuillez saisir votre nom"
}

# Si rien n'est saisi, utiliser "invité"
if (-not $nom) {
    $nom = "invité"
}

# Vérification du nom Administrateur / Administrator
if ($nom -eq "Administrateur" -or $nom -eq "Administrator") {
    Write-Host "Erreur : le nom '$nom' n'est pas autorisé." -ForegroundColor Red
    exit 4
}

# Affichage du message de bienvenue avec le nom de la machine
Write-Host "Bienvenue $nom sur la machine $($env:COMPUTERNAME)"

# Fin du script
Write-Host "fin du script"
``