# Import du module Active Directory
Import-Module ActiveDirectory -ErrorAction Stop

Write-Host "=== Gestion de l'état d'un compte utilisateur AD ===" -ForegroundColor Cyan

# Demande du nom de l'utilisateur (SamAccountName)
$NomUtilisateur = Read-Host "Entrez le nom du compte utilisateur (SamAccountName)"

try {
    # Récupération de l'utilisateur
    $Utilisateur = Get-ADUser -Identity $NomUtilisateur -Properties Enabled
}
catch {
    Write-Host "Erreur : le compte '$NomUtilisateur' est introuvable." -ForegroundColor Red
    exit
}

# Affichage de l'état actuel
if ($Utilisateur.Enabled) {
    Write-Host "État actuel du compte : ACTIVÉ" -ForegroundColor Green
} else {
    Write-Host "État actuel du compte : DÉSACTIVÉ" -ForegroundColor Yellow
}

Write-Host ""
Write-Host "Choisissez l'action à effectuer :"
Write-Host "1 - Activer le compte"
Write-Host "2 - Désactiver le compte"

$Choix = Read-Host "Votre choix (1 ou 2)"

switch ($Choix) {

    "1" {
        Enable-ADAccount -Identity $NomUtilisateur
        Write-Host "Le compte a été activé." -ForegroundColor Green
    }

    "2" {
        Disable-ADAccount -Identity $NomUtilisateur
        Write-Host "Le compte a été désactivé." -ForegroundColor Yellow
    }

    default {
        Write-Host "Choix invalide. Aucune modification effectuée." -ForegroundColor Red
        exit
    }
}

# Vérification finale de l'état du compte
$EtatFinal = (Get-ADUser -Identity $NomUtilisateur -Properties Enabled).Enabled

Write-Host ""
if ($EtatFinal) {
    Write-Host "État final du compte : ACTIVÉ" -ForegroundColor Green
} else {
    Write-Host "État final du compte : DÉSACTIVÉ" -ForegroundColor Yellow
}

Write-Host "=== Fin du script ==="