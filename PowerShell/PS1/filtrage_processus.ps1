# ==============================
# Script : filtrage_processus.ps1
# Objectif : Filtrer les processus selon un mot-clé saisi par l'utilisateur
# ==============================

# Demande du mot-clé
$motCle = Read-Host "Entrez le mot-clé à rechercher dans le nom des processus"

# Filtrage et affichage des processus
Get-Process | Where-Object {
    $_.ProcessName -like "*$motCle*"
}