Write-Host "=== Gestion des groupes locaux ===" -ForegroundColor Cyan

# Demande du nom du groupe
$NomGroupe = Read-Host "Entrez le nom du groupe local à créer ou gérer"

# Vérification de l'existence du groupe
$GroupeExiste = Get-LocalGroup -Name $NomGroupe -ErrorAction SilentlyContinue

if (-not $GroupeExiste) {
    Write-Host "Le groupe '$NomGroupe' n'existe pas. Création du groupe..." -ForegroundColor Yellow
    New-LocalGroup -Name $NomGroupe
    Write-Host "Groupe créé avec succès." -ForegroundColor Green
} else {
    Write-Host "Le groupe '$NomGroupe' existe déjà." -ForegroundColor Green
}

do {
    # Demande du nom de l'utilisateur
    $NomUtilisateur = Read-Host "Entrez le nom de l'utilisateur à ajouter au groupe"

    try {
        # Ajout de l'utilisateur au groupe
        Add-LocalGroupMember -Group $NomGroupe -Member $NomUtilisateur
        Write-Host "Utilisateur '$NomUtilisateur' ajouté au groupe '$NomGroupe'." -ForegroundColor Green
    }
    catch {
        Write-Host "Erreur : impossible d'ajouter l'utilisateur '$NomUtilisateur'." -ForegroundColor Red
    }

    # Demande si un autre ajout est nécessaire
    $Choix = Read-Host "Voulez-vous ajouter un autre utilisateur ? (O/N)"

} while ($Choix -match "^[Oo]$")

# Affichage des membres du groupe
Write-Host ""
Write-Host "=== Membres du groupe '$NomGroupe' ===" -ForegroundColor Cyan

Get-LocalGroupMember -Group $NomGroupe |
    Select-Object Name, ObjectClass |
    Format-Table -AutoSize

Write-Host "=== Fin du script ==="