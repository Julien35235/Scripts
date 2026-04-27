# ==============================
# Script : gestion_repertoires.ps1
# Objectif : Créer une arborescence et déplacer un fichier
# ==============================

# Demande du nom du répertoire principal
$repertoirePrincipal = Read-Host "Entrez le nom du répertoire principal à créer"

# Demande du nom du sous-répertoire
$sousRepertoire = Read-Host "Entrez le nom du sous-répertoire à créer"

# Récupération du répertoire personnel de l'utilisateur
$homePath = $HOME

# Construction des chemins complets
$cheminPrincipal = Join-Path $homePath $repertoirePrincipal
$cheminSousRepertoire = Join-Path $cheminPrincipal $sousRepertoire

# Création de l'arborescence
New-Item -ItemType Directory -Path $cheminSousRepertoire -Force | Out-Null

Write-Host "Arborescence créée : $cheminSousRepertoire"

# Demande du nom du fichier à déplacer (chemin complet ou relatif)
$fichierSource = Read-Host "Entrez le chemin complet du fichier à déplacer"

# Vérification de l'existence du fichier
if (Test-Path $fichierSource) {

    # Déplacement du fichier
    Move-Item -Path $fichierSource -Destination $cheminSousRepertoire

    Write-Host "Le fichier a été déplacé avec succès dans le sous-répertoire."
}
else {
    Write-Host "Erreur : le fichier spécifié n'existe pas." -ForegroundColor Red
}
