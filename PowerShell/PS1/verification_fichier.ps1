# verification_fichier.ps1
# Ce script demande un nom de fichier, vérifie son existence
# et affiche un message en fonction du résultat.

# Demander à l’utilisateur le nom du fichier à vérifier
$nomFichier = Read-Host "Entrez le nom (ou le chemin) du fichier à vérifier"

# Tester l’existence du fichier
if (Test-Path $nomFichier) {
    Write-Host "Le fichier '$nomFichier' existe."
} else {
    Write-Host "Le fichier '$nomFichier' n'existe pas."
}
``