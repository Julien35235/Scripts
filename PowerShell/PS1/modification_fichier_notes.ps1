# Demander le nom du fichier
Write-Host "Entrez le nom du fichier à créer ou à modifier :"
$fichier = Read-Host

# Demander la première ligne de texte
Write-Host "Entrez la première ligne de texte :"
$ligne1 = Read-Host

# Écrire la première ligne (création ou écrasement du fichier)
$ligne1 | Out-File -FilePath $fichier -Encoding UTF8

# Demander la seconde ligne de texte
Write-Host "Entrez la seconde ligne de texte :"
$ligne2 = Read-Host

# Ajouter la seconde ligne au fichier
$ligne2 | Out-File -FilePath $fichier -Append -Encoding UTF8

# Afficher le contenu final du fichier
Write-Host "`nContenu final du fichier :"
Get-Content $fichier